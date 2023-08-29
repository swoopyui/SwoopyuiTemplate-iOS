//
// The script that will start the python app

import Foundation
import PythonSupport

func startPythonSwoopyuiHost () {
    PythonSupport.initialize()
    PythonSupport.runSimpleString("""
    from swoopyui_app import *
    """)
}

