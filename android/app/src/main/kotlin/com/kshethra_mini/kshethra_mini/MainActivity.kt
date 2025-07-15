package com.kshethra_mini.kshethra_mini

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.io.OutputStream
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "printer_channel"
    private val REQUEST_BLUETOOTH_PERMISSIONS = 1001
    private val MY_UUID: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
    private var bluetoothAdapter: BluetoothAdapter? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "printReceipt") {
                if (!checkPermissions()) {
                    requestPermissions()
                    result.error("PERMISSION", "Bluetooth permissions not granted", null)
                    return@setMethodCallHandler
                }

                val printResult = printReceipt(call)
                if (printResult == null) {
                    result.success("Printed successfully")
                } else {
                    result.error("PRINT_ERROR", printResult, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun checkPermissions(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED &&
                    ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED &&
                    ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
        } else {
            ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
        }
    }

    private fun requestPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(
                    Manifest.permission.BLUETOOTH_CONNECT,
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.ACCESS_FINE_LOCATION
                ),
                REQUEST_BLUETOOTH_PERMISSIONS
            )
        } else {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                REQUEST_BLUETOOTH_PERMISSIONS
            )
        }
    }

    private fun printReceipt(call: MethodCall): String? {
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter == null) return "Bluetooth not supported"
        if (!bluetoothAdapter!!.isEnabled) bluetoothAdapter!!.enable()

        val pairedDevices: Set<BluetoothDevice> = bluetoothAdapter!!.bondedDevices
        if (pairedDevices.isEmpty()) return "No paired Bluetooth devices found"

        val device = pairedDevices.first() // You can add device selection logic

        return try {
            val socket: BluetoothSocket = device.createRfcommSocketToServiceRecord(MY_UUID)
            socket.connect()

            val outputStream: OutputStream = socket.outputStream
            val textToPrint = call.argument<String>("text") ?: "No text received"

            printLongText(outputStream, textToPrint)

            outputStream.flush()
            outputStream.close()
            socket.close()
            null // success
        } catch (e: IOException) {
            Log.e("Printer", "Printing failed", e)
            "Printing failed: ${e.message}"
        }
    }

    private fun printLongText(outputStream: OutputStream, text: String) {
        val chunkSize = 256
        var i = 0
        while (i < text.length) {
            val end = (i + chunkSize).coerceAtMost(text.length)
            val chunk = text.substring(i, end)
            outputStream.write(chunk.toByteArray())
            outputStream.flush()
            i += chunkSize
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_BLUETOOTH_PERMISSIONS && checkPermissions()) {
            Log.d("Printer", "Bluetooth permissions granted")
        }
    }
}
