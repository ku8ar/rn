package com.bridge
import android.app.Application
import android.os.Bundle
import com.facebook.react.common.LifecycleState
import android.content.Context
import android.util.AttributeSet
import com.facebook.react.ReactRootView
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactPackage
import com.facebook.react.shell.MainReactPackage

class BridgeReactView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null
) : ReactRootView(context, attrs) {

    private var instanceManager: ReactInstanceManager? = null

    fun initialize(jsBundleAssetName: String = "index.android.bundle", initialProps: Bundle? = null) {
        if (instanceManager == null) {
            val application = context.applicationContext as Application

            instanceManager = ReactInstanceManager.builder()
                .setApplication(application)
                .setBundleAssetName(jsBundleAssetName)
                .setJSMainModulePath("index")
                .addPackage(MainReactPackage())
                .setUseDeveloperSupport(false)
                .setInitialLifecycleState(LifecycleState.RESUMED)
                .build()
        }
        this.startReactApplication(
            instanceManager,
            "rnbridge",
            initialProps
        )
    }
}
