package com.kshethra_mini.kshethra_mini

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import net.posprinter.IDeviceConnection
import net.posprinter.IPOSListener
import net.posprinter.POSConnect
import net.posprinter.POSConst
import net.posprinter.POSPrinter


class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.panel_printer"
    private var curConnect: IDeviceConnection? = null
    private var firstImageBytes: ByteArray? = null
    private var secondImageBytes: ByteArray? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "printReceipt" -> {
                    // For backward compatibility - single image printing
                    firstImageBytes = call.argument<ByteArray>("image")
                    configPrinter(result, false)
                }
                "printTwoReceipts" -> {
                    // New method for printing two arrays separately
                    firstImageBytes = call.argument<ByteArray>("firstImage")
                    secondImageBytes = call.argument<ByteArray>("secondImage")
                    configPrinter(result, true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun configPrinter(result: MethodChannel.Result, printTwoReceipts: Boolean) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                POSConnect.init(this@MainActivity)

                val entries = POSConnect.getUsbDevices(this@MainActivity)

                if (entries.isNotEmpty()) {
                    try {
                        if (printTwoReceipts) {
                            printTwoReceipts(entries[0], result)
                        } else {
                            printReceipt(entries[0], result)
                        }
                    } catch (e: Exception) {
                        withContext(Dispatchers.Main) {
                            result.error("PRINT_ERROR", "Error printing receipt: ${e.message}", null)
                        }
                    }
                } else {
                    withContext(Dispatchers.Main) {
                        result.error("NO_PRINTER", "No USB printers found", null)
                    }
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error("CONFIG_ERROR", "Error occurred: ${e.message}", null)
                }
            }
        }
    }

    private fun printReceipt(pathName: String, result: MethodChannel.Result) {
        curConnect?.close()
        curConnect = POSConnect.createDevice(POSConnect.DEVICE_TYPE_USB)
        curConnect!!.connect(pathName, connectListener(result, false))
    }

    private fun printTwoReceipts(pathName: String, result: MethodChannel.Result) {
        curConnect?.close()
        curConnect = POSConnect.createDevice(POSConnect.DEVICE_TYPE_USB)
        curConnect!!.connect(pathName, connectListener(result, true))
    }

    private fun connectListener(result: MethodChannel.Result, printTwoReceipts: Boolean) = IPOSListener { code, _ ->
        when (code) {
            POSConnect.CONNECT_SUCCESS -> {
                if (printTwoReceipts) {
                    firstImageBytes?.let { firstImage ->
                        secondImageBytes?.let { secondImage ->
                            // Use sequential printing with delays for better cutting
                            CoroutineScope(Dispatchers.IO).launch {
                                try {
                                    printReceiptsSequentially(firstImage, secondImage)
                                    withContext(Dispatchers.Main) {
                                        result.success("Print Success - Two Receipts")
                                    }
                                } catch (e: Exception) {
                                    withContext(Dispatchers.Main) {
                                        result.error("PRINT_ERROR", "Error printing receipts: ${e.message}", null)
                                    }
                                }
                            }
                        } ?: run {
                            result.error("IMAGE_ERROR", "Second image data not available", null)
                        }
                    } ?: run {
                        result.error("IMAGE_ERROR", "First image data not available", null)
                    }
                } else {
                    firstImageBytes?.let {
                        initImagePrint(it)
                        result.success("Print Success")
                    } ?: run {
                        result.error("IMAGE_ERROR", "No image data available", null)
                    }
                }
            }
            POSConnect.CONNECT_FAIL,
            POSConnect.CONNECT_INTERRUPT,
            POSConnect.SEND_FAIL,
            POSConnect.USB_DETACHED,
            POSConnect.USB_ATTACHED -> {
                result.error("CONNECT_FAIL", "Printer connection failed", null)
            }
        }
    }

    private fun initImagePrint(imageBytes: ByteArray) {
        val printer = POSPrinter(curConnect)

        // Convert the byte array to Bitmap
        val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)

        printer.printBitmap(bitmap, POSConst.ALIGNMENT_CENTER, 600)

        // Add spacing before cut
        printer.feedLine(3)

        // Cut paper - try multiple cut methods
        try {
            printer.cutHalfAndFeed(3)
        } catch (e: Exception) {
            // Fallback cutting methods
            try {
                printer.cutPaper()
            } catch (e2: Exception) {
                // If cutting fails, just feed more lines
                printer.feedLine(5)
            }
        }
    }

    private fun initTwoImagePrint(firstImageBytes: ByteArray, secondImageBytes: ByteArray) {
        val printer = POSPrinter(curConnect)

        // Print first image
        val firstBitmap = BitmapFactory.decodeByteArray(firstImageBytes, 0, firstImageBytes.size)
        printer.printBitmap(firstBitmap, POSConst.ALIGNMENT_CENTER, 600)

        // Add spacing before cut
        printer.feedLine(3)

        // Cut paper after first image - try multiple cut methods
        try {
            printer.cutHalfAndFeed(1)
        } catch (e: Exception) {
            // Fallback cutting methods
            try {
                printer.cutPaper()
            } catch (e2: Exception) {
                // If cutting fails, just feed more lines
                printer.feedLine(5)
            }
        }

        // Add more spacing between receipts
        printer.feedLine(5)

        // Print second image
        val secondBitmap = BitmapFactory.decodeByteArray(secondImageBytes, 0, secondImageBytes.size)
        printer.printBitmap(secondBitmap, POSConst.ALIGNMENT_CENTER, 600)

        // Add spacing before final cut
        printer.feedLine(3)

        // Cut paper after second image - try multiple cut methods
        try {
            printer.cutHalfAndFeed(1)
        } catch (e: Exception) {
            // Fallback cutting methods
            try {
                printer.cutPaper()
            } catch (e2: Exception) {
                // If cutting fails, just feed more lines
                printer.feedLine(5)
            }
        }
    }

    // Alternative method to print receipts one by one with delays
    private suspend fun printReceiptsSequentially(firstImageBytes: ByteArray, secondImageBytes: ByteArray) {
        val printer = POSPrinter(curConnect)

        // Print first receipt
        val firstBitmap = BitmapFactory.decodeByteArray(firstImageBytes, 0, firstImageBytes.size)
        printer.printBitmap(firstBitmap, POSConst.ALIGNMENT_CENTER, 600)
        printer.feedLine(3)

        // Try to cut after first receipt
        try {
            printer.cutHalfAndFeed(1)
        } catch (e: Exception) {
            try {
                printer.cutPaper()
            } catch (e2: Exception) {
                printer.feedLine(5)
            }
        }

        // Wait a bit for the cut to complete
        delay(1000)

        // Print second receipt
        val secondBitmap = BitmapFactory.decodeByteArray(secondImageBytes, 0, secondImageBytes.size)
        printer.printBitmap(secondBitmap, POSConst.ALIGNMENT_CENTER, 600)
        printer.feedLine(3)

        // Try to cut after second receipt
        try {
            printer.cutHalfAndFeed(1)
        } catch (e: Exception) {
            try {
                printer.cutPaper()
            } catch (e2: Exception) {
                printer.feedLine(5)
            }
        }
    }
}