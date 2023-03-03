package com.monnifyreactnativev2;

import androidx.annotation.NonNull;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.teamapt.monnify.sdk.Monnify;
import com.teamapt.monnify.sdk.MonnifyTransactionResponse;
import com.teamapt.monnify.sdk.data.model.TransactionDetails;
import com.teamapt.monnify.sdk.data.model.TransactionType;
import com.teamapt.monnify.sdk.rest.data.request.SubAccountDetails;
import com.teamapt.monnify.sdk.service.ApplicationMode;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.math.BigDecimal;

@ReactModule(name = MonnifyReactNativeV2Module.NAME)
public class MonnifyReactNativeV2Module extends ReactContextBaseJavaModule implements ActivityEventListener {
  private static final String TAG = MonnifyReactNativeV2Module.class.getSimpleName();
  private static final int INITIATE_PAYMENT_REQUEST_CODE = 9889;
  private static final String REACT_CLASS = "MonnifyReactNativeV2Module";
  private static final String MONNIFY_RESULT_KEY = "MONNIFY_RESULT_KEY";

  private static final String KEY_CONTRACT_CODE = "contractCode";
  private static final String KEY_API_KEY = "apiKey";
  private static final String KEY_TRANSACTION_REFERENCE = "transactionReference";
  private static final String KEY_TRANSACTION_STATUS = "transactionStatus";
  private static final String KEY_PAYMENT_METHOD = "paymentMethod";
  private static final String KEY_APPLICATION_MODE = "applicationMode";
  private static final String APPLICATION_MODE_TEST = "TEST";
  private static final String APPLICATION_MODE_LIVE = "LIVE";
  private static final String KEY_AMOUNT = "amount";
  private static final String KEY_ERROR_TYPE = "errorType";
  private static final String KEY_ERROR = "error";
  private static final String KEY_AMOUNT_PAID = "amountPaid";
  private static final String KEY_PAYMENT_DATE = "paymentDate";
  private static final String KEY_AMOUNT_PAYABLE = "amountPayable";
  private static final String KEY_CUSTOMER_NAME = "customerName";
  private static final String KEY_CUSTOMER_EMAIL = "customerEmail";
  private static final String KEY_PAYMENT_REFERENCE = "paymentReference";
  private static final String KEY_PAYMENT_DESCRIPTION = "paymentDescription";
  private static final String KEY_CURRENCY_CODE = "currencyCode";
  private static final String KEY_INCOMING_SPLIT_CONFIG = "incomeSplitConfig";
  private static final String KEY_SUB_ACCOUNT_CODE = "subAccountCode";
  private static final String KEY_SUB_ACCOUNT_FEE_PERCENTAGE = "feePercentage";
  private static final String KEY_SUB_ACCOUNT_SPLIT_AMOUNT = "splitAmount";
  private static final String KEY_SUB_ACCOUNT_IS_FEE_BEARER = "feeBearer";
  private static final String PAYMENT_INITIALIZATION_ERROR_CODE = "EIOS001";

  private Promise completionPromise;
  private Monnify monnify;
  public static final String NAME = "MonnifyReactNativeV2";

  public MonnifyReactNativeV2Module(ReactApplicationContext reactContext) {
    super(reactContext);
    reactContext.addActivityEventListener(this);
    monnify = Monnify.Companion.getInstance();
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }


  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  public void multiply(double a, double b, Promise promise) {
    promise.resolve(40);
  }

  @ReactMethod
  public void initialize(ReadableMap options) {
    if (hasStringKey(KEY_API_KEY, options)) {
      String apiKey = options.getString(KEY_API_KEY);
      monnify.setApiKey(apiKey);
    }

    if (hasStringKey(KEY_CONTRACT_CODE, options)) {
      String contractCode = options.getString(KEY_CONTRACT_CODE);
      monnify.setContractCode(contractCode);
    }

    if (hasStringKey(KEY_APPLICATION_MODE, options)) {
      String applicationMode = options.getString(KEY_APPLICATION_MODE);
      monnify.setApplicationMode(ApplicationMode.valueOf(applicationMode));

    }
  }

  @ReactMethod
  public void initializePayment(ReadableMap options, Promise completionPromise) {

    this.completionPromise = completionPromise;

    validateMonnifyInit();

    BigDecimal amount = null;
    String customerName = null;
    String customerEmail = null;
    String paymentReference = null;
    String paymentDescription = null;
    String currencyCode = null;
    ReadableArray incomeSplitConfig = null;

    if (options.hasKey(KEY_AMOUNT)) {
      amount = BigDecimal.valueOf(options.getInt(KEY_AMOUNT));
    }

    if (hasStringKey(KEY_CUSTOMER_NAME, options)) {
      customerName = options.getString(KEY_CUSTOMER_NAME);
    }

    if (hasStringKey(KEY_CUSTOMER_EMAIL, options)) {
      customerEmail = options.getString(KEY_CUSTOMER_EMAIL);
    }

    if (hasStringKey(KEY_PAYMENT_REFERENCE, options)) {
      paymentReference = options.getString(KEY_PAYMENT_REFERENCE);
    }

    if (hasStringKey(KEY_PAYMENT_DESCRIPTION, options)) {
      paymentDescription = options.getString(KEY_PAYMENT_DESCRIPTION);
    }

    if (hasStringKey(KEY_CURRENCY_CODE, options)) {
      currencyCode = options.getString(KEY_CURRENCY_CODE);
    }

    if (options.hasKey(KEY_INCOMING_SPLIT_CONFIG)) {
      incomeSplitConfig = options.getArray(KEY_INCOMING_SPLIT_CONFIG);
    }

    if (!isTransactionDetailsValid(amount, currencyCode, paymentReference, customerEmail))
      return;


    if (!isSubAccountsValid(incomeSplitConfig)) {
      rejectPromise(PAYMENT_INITIALIZATION_ERROR_CODE,
        "One of the sub accounts is null or does not have a subAccountCode");
      return;
    }

    List<SubAccountDetails> subAccountDetails = subAccountDetailsFromReadableArray(incomeSplitConfig);

    TransactionDetails transactionDetails = new TransactionDetails.Builder().amount(amount)
      .currencyCode(currencyCode)
      .customerEmail(customerEmail)
      .customerName(customerName)
      .paymentReference(paymentReference)
      .paymentDescription(paymentDescription)
      .incomeSplitConfig(subAccountDetails)
      .build();

    Activity activity = getCurrentActivity();

    if (activity != null) {
      monnify.initializePayment(activity, transactionDetails, INITIATE_PAYMENT_REQUEST_CODE, MONNIFY_RESULT_KEY);
    } else {
      rejectPromise(PAYMENT_INITIALIZATION_ERROR_CODE, "Something weird happened, Activity is Null");
    }
  }

  private List<SubAccountDetails> subAccountDetailsFromReadableArray(ReadableArray incomeSplitConfig) {
    List<SubAccountDetails> subAccountDetails = new ArrayList<>();

    if (incomeSplitConfig == null){
      return subAccountDetails;
    }
    for (int i = 0; i < incomeSplitConfig.size(); i++) {
      ReadableMap subAccountOptions = incomeSplitConfig.getMap(i);
      if (subAccountOptions != null && !hasStringKey(KEY_SUB_ACCOUNT_CODE, subAccountOptions)) {
        String subAccountCode = subAccountOptions.getString(KEY_SUB_ACCOUNT_CODE);
        Float fee = (float)subAccountOptions.getDouble(KEY_SUB_ACCOUNT_FEE_PERCENTAGE);
        Integer splitAmount = subAccountOptions.getInt(KEY_SUB_ACCOUNT_SPLIT_AMOUNT);
        boolean subAccountIsBearer = subAccountOptions.getBoolean(KEY_SUB_ACCOUNT_IS_FEE_BEARER);

        SubAccountDetails details = new SubAccountDetails(subAccountCode, fee,BigDecimal.valueOf(splitAmount), subAccountIsBearer);
        subAccountDetails.add(details);
      }
    }

    return subAccountDetails;
  }

  private void validateMonnifyInit() {

    if (isEmpty(monnify.getApiKey())) {
      rejectPromise(PAYMENT_INITIALIZATION_ERROR_CODE,
        "Call init(ReadableMap options) with your apiKey passed with key " + KEY_API_KEY);
      return;
    }

    if (isEmpty(monnify.getContractCode())) {
      rejectPromise(PAYMENT_INITIALIZATION_ERROR_CODE,
        "Call init(ReadableMap options) with your contractCode passed with key " + KEY_API_KEY);
    }
  }

  private boolean isSubAccountsValid(ReadableArray incomeSplitConfig) {

    if (incomeSplitConfig == null) return true;

    for (int i = 0; i < incomeSplitConfig.size(); i++) {
      ReadableMap subAccountOptions = incomeSplitConfig.getMap(i);
      if (subAccountOptions != null && !hasStringKey(KEY_SUB_ACCOUNT_CODE, subAccountOptions)) {
        return false;
      }
    }

    return true;
  }

  private boolean isTransactionDetailsValid(BigDecimal amount, String currencyCode, String paymentReference, String customerEmail) {

    if (amount == null || amount.intValue() < 1) {
      rejectPromise(PAYMENT_INITIALIZATION_ERROR_CODE, "Invalid amount");
      return false;
    }

    if (isEmpty(customerEmail)) {
      rejectPromise(PAYMENT_INITIALIZATION_ERROR_CODE, "Customer Email cannot be empty");
      return false;
    }

    if (isEmpty(currencyCode)) {
      rejectPromise(PAYMENT_INITIALIZATION_ERROR_CODE, "Currency code cannot be empty");
      return false;
    }

    if (isEmpty(currencyCode)) {
      rejectPromise(PAYMENT_INITIALIZATION_ERROR_CODE, "Currency code cannot be empty");
      return false;
    }


    if (isEmpty(paymentReference)) {
      rejectPromise(PAYMENT_INITIALIZATION_ERROR_CODE, "Payment Reference cannot be empty");
      return false;
    }

    return true;
  }

  private boolean isEmpty(String s) {
    return s == null || s.length() == 0;
  }

  private boolean hasStringKey(String key, ReadableMap options) {
    return options.hasKey(key) && !options.isNull(key) && !options.getString(key).isEmpty();
  }

  private void rejectPromise(String code, String message) {
    if (this.completionPromise != null) {
      this.completionPromise.reject(code, message);
      this.completionPromise = null;
    }
  }

  private void resolvePromise(Object data) {
    if (this.completionPromise != null) {
      this.completionPromise.resolve(data);
      this.completionPromise = null;
    }
  }


  @Override
  public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
    if (data==null){
      return;
    }

    MonnifyTransactionResponse monnifyTransactionResponse = data.getParcelableExtra(MonnifyReactNativeV2Module.MONNIFY_RESULT_KEY);
    if(monnifyTransactionResponse==null){
      return;
    }
    WritableMap map = new WritableNativeMap();

    Log.d(TAG, "MonnifyTransactionResponse Response" + monnifyTransactionResponse.toString());

    String paymentMethod = "";
    TransactionType responsePaymentMethod = monnifyTransactionResponse.getPaymentMethod();
    if (responsePaymentMethod != null){
      paymentMethod = responsePaymentMethod.name();
    }

    map.putString(KEY_TRANSACTION_REFERENCE, monnifyTransactionResponse.getTransactionReference());
    map.putString(KEY_TRANSACTION_STATUS, monnifyTransactionResponse.getStatus().name());
    map.putString(KEY_PAYMENT_METHOD, paymentMethod);
    map.putString(KEY_AMOUNT_PAID, monnifyTransactionResponse.getAmountPaid().toPlainString());
    map.putString(KEY_AMOUNT_PAYABLE, monnifyTransactionResponse.getAmountPayable().toPlainString());
    map.putString(KEY_PAYMENT_DATE, monnifyTransactionResponse.getPaidOn());
    map.putString(KEY_PAYMENT_REFERENCE, monnifyTransactionResponse.getPaymentReference());

    Log.d(TAG, "WritableMap Response" + map.toString());

    resolvePromise(map);
  }

  @Override
  public void onNewIntent(Intent intent) {
  }
}
