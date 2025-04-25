package com.bridge

import android.app.Application
import android.os.Bundle
import android.content.Context
import android.util.AttributeSet
import android.widget.FrameLayout
import com.facebook.react.ReactInstanceManager
import com.facebook.react.shell.MainReactPackage
import com.facebook.react.common.LifecycleState
import com.facebook.react.ReactRootView
import com.facebook.react.soloader.OpenSourceMergedSoMapping
import com.facebook.soloader.SoLoader

// start: MANUAL LINKING
import com.onfido.reactnative.sdk.OnfidoSdkPackage
import com.callstack.repack.ScriptManagerPackage
import com.th3rdwave.safeareacontext.SafeAreaContextPackage
import com.swmansion.rnscreens.RNScreensPackage
// end: MANUAL LINKING

class BridgeReactView(context: Context) : FrameLayout(context) {

    private var instanceManager: ReactInstanceManager? = null
    private var reactRootView: ReactRootView? = null

    init {
        if (instanceManager == null) {
            val application = context.applicationContext as Application

            SoLoader.init(application, OpenSourceMergedSoMapping)

            instanceManager = ReactInstanceManager.builder()
                .setApplication(application)
                .setCurrentActivity(null)
                .setBundleAssetName("index.android.bundle")
                .setJSMainModulePath("index")
                .addPackage(MainReactPackage())
                // start: MANUAL LINKING
                .addPackage(OnfidoSdkPackage())
                .addPackage(ScriptManagerPackage())
                .addPackage(SafeAreaContextPackage())
                .addPackage(RNScreensPackage())
                // end: MANUAL LINKING
                .setUseDeveloperSupport(false)
                .setInitialLifecycleState(LifecycleState.BEFORE_CREATE)
                .build()
        }
        if (reactRootView == null) {
            reactRootView = ReactRootView(context)
            reactRootView?.startReactApplication(
                instanceManager,
                "rnbridge",
                null
            )
            addView(reactRootView, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))
        }
    }
}
