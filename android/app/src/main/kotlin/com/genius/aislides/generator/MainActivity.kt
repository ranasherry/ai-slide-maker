package com.genius.aislides.generator

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Environment
import java.io.File
import java.util.*
import androidx.annotation.NonNull

class MainActivity : FlutterActivity() {


    companion object {
        private var pdfFiles: List<String> = ArrayList()
        private var pptFiles: List<String> = ArrayList()
        private var currentIndex: Int = 0
        private var firstTime: Int = 0
        private var currentIndexPPT: Int = 0
        private var firstTimePPT: Int = 0
        private const val PAGE_SIZE = 10
    }

//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
////        getPdfFiles()
//    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pdf_files").setMethodCallHandler { call, result ->
//            if(firstTime == 0){
//                getPdfFiles()
//                firstTime++
//            }
            if (call.method == "getPdfFiles") {

                if(firstTime == 0){
                    getPdfFiles()
                    firstTime++
                }

                result.success(getNextPdfFiles())
//                return
            }

            else if (call.method == "getPPTFiles") {
                if(firstTimePPT == 0){
                    getPPTFiles()
                    firstTimePPT++
                }

                result.success(getNextPPTFiles())

            }
           else if (call.method == "resetMethodChannel") {
            result.success(resetMethod())
//                return
            }

            else {
                result.notImplemented()
            }
        }
    }

    private fun getPdfFiles() {
        val path = Environment.getExternalStorageDirectory().toString()
        val pdfFiles = ArrayList<String>()
        val directory = File(path)
        val files = directory.listFiles()
        if (files != null) {
            for (file in files) {
                if (file.isDirectory) {
                    pdfFiles.addAll(getPdfFilesFromDirectory(file))
                } 
                //else if (file.name.endsWith(".pdf")) 
                else if (file.name.endsWith(".pdf"))
                {
                    pdfFiles.add(file.absolutePath)
                }
            }
        }
        MainActivity.pdfFiles = pdfFiles
    }
    private fun getPPTFiles() {
        val path = Environment.getExternalStorageDirectory().toString()
        val pdfFiles = ArrayList<String>()
        val directory = File(path)
        val files = directory.listFiles()
        if (files != null) {
            for (file in files) {
                if (file.isDirectory) {
                    pdfFiles.addAll(getPPTilesFromDirectory(file))
                }
                //else if (file.name.endsWith(".pdf"))
                else if (file.name.endsWith(".pptx"))
                {
                    pdfFiles.add(file.absolutePath)
                }
            }
        }
        MainActivity.pptFiles = pdfFiles
    }

    private fun getPPTilesFromDirectory(directory: File): List<String> {
        val PptFiles = ArrayList<String>()
        val files = directory.listFiles()
        if (files != null) {
            for (file in files) {
                if (file.isDirectory) {
                    PptFiles.addAll(getPPTilesFromDirectory(file))
                } 
                else if (file.name.endsWith(".pptx"))
                // else if (file.name.endsWith(".pdf"))
                 {
                     PptFiles.add(file.absolutePath)
                }
            }
        }
        return PptFiles
    }  private fun getPdfFilesFromDirectory(directory: File): List<String> {
        val pdfFiles = ArrayList<String>()
        val files = directory.listFiles()
        if (files != null) {
            for (file in files) {
                if (file.isDirectory) {
                    pdfFiles.addAll(getPdfFilesFromDirectory(file))
                }
                else if (file.name.endsWith(".pdf"))
                // else if (file.name.endsWith(".pdf"))
                 {
                    pdfFiles.add(file.absolutePath)
                }
            }
        }
        return pdfFiles
    }

    private fun getNextPdfFiles(): List<String> {
        if (currentIndex >= pdfFiles.size) {
            return emptyList()
        }

        val remainingFiles = pdfFiles.subList(currentIndex, minOf(currentIndex + PAGE_SIZE, pdfFiles.size))
        currentIndex += PAGE_SIZE
        return remainingFiles
    }

    private fun getNextPPTFiles(): List<String> {
        if (currentIndexPPT >= pptFiles.size) {
            return emptyList()
        }

        val remainingFiles = pptFiles.subList(currentIndexPPT, minOf(currentIndexPPT + PAGE_SIZE, pptFiles.size))
        currentIndexPPT += PAGE_SIZE
        return remainingFiles
    }

    private fun resetMethod(): List<String> {
        pdfFiles= ArrayList()
        pptFiles= ArrayList()
         currentIndex= 0
         firstTime = 0
       currentIndexPPT = 0
        firstTimePPT= 0

        return pptFiles
    }

}
