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
    private var imageBytes: ByteArray? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "printReceipt") {
                imageBytes = call.argument<ByteArray>("image")
                configPrinter(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun configPrinter(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                POSConnect.init(this@MainActivity)

                val entries = POSConnect.getUsbDevices(this@MainActivity)

                if (entries.isNotEmpty()) {
                    try {
                        printReceipt(entries[0], result)
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
        curConnect!!.connect(pathName, connectListener(result))
    }

    private fun connectListener(result: MethodChannel.Result) = IPOSListener { code, _ ->
        when (code) {
            POSConnect.CONNECT_SUCCESS -> {
                imageBytes?.let {
                    initImagePrint(it) // Pass the imageBytes to the print function
                    result.success("Print Success")
                } ?: run {
                    result.error("IMAGE_ERROR", "No image data available", null)
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

        printer.cutHalfAndFeed(1) // Optional, depending on your printer's features

    }
}