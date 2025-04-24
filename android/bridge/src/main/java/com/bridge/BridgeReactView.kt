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

class BridgeReactView(context: Context) : FrameLayout(context) {

    private var instanceManager: ReactInstanceManager? = null
    private var reactRootView: ReactRootView? = null

    init {
        if (instanceManager == null) {
            val application = context.applicationContext as Application

            instanceManager = ReactInstanceManager.builder()
                .setApplication(application)
                .setCurrentActivity(null)
                .setBundleAssetName("index.android.bundle")
                .setJSMainModulePath("index")
                .addPackage(MainReactPackage())
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
