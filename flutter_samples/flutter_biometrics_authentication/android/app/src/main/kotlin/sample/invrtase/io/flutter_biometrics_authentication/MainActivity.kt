package sample.invertase.io.flutter_biometrics_authentication

import androidx.annotation.NonNull
import androidx.biometric.BiometricManager.Authenticators.BIOMETRIC_STRONG
import androidx.biometric.BiometricManager.Authenticators.DEVICE_CREDENTIAL
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.biometric.BiometricPrompt.AUTHENTICATION_RESULT_TYPE_UNKNOWN
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "samples.invertase.io/biometrics"
    private lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        );

        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "authenticateWithBiometrics") {
                authenticateWithBiometrics(result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun authenticateWithBiometrics(@NonNull result: MethodChannel.Result) {
        var resultSent: Boolean = false;
        val executor = ContextCompat.getMainExecutor(this)
        val biometricPrompt = BiometricPrompt(
            this as FragmentActivity, executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationError(
                    errorCode: Int,
                    errString: CharSequence
                ) {
                    super.onAuthenticationError(errorCode, errString)
                    if (errorCode != 10 && !resultSent) {
                        result.error("AUTHFAILED", errString.toString(), null)
                        resultSent = true;
                    }
                }

                override fun onAuthenticationSucceeded(
                    authResult: BiometricPrompt.AuthenticationResult
                ) {
                    super.onAuthenticationSucceeded(authResult)
                    if (!resultSent) {
                        result.success(null)
                        resultSent = true;
                    }
                    methodChannel.invokeMethod(
                        "authenticationResult",
                        authResult.authenticationType != AUTHENTICATION_RESULT_TYPE_UNKNOWN
                    )
                }

                override fun onAuthenticationFailed() {
                    super.onAuthenticationFailed()
                    if (!resultSent) {
                        result.error("AUTHFAILED", "Unknown", null)
                        resultSent = true;
                    }
                }
            })

        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Biometric login")
            .setSubtitle("Log in using your biometric credential")
            .setConfirmationRequired(false)
            .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_STRONG or BiometricManager.Authenticators.DEVICE_CREDENTIAL)
            .build()

        biometricPrompt.authenticate(promptInfo)
    }
}
