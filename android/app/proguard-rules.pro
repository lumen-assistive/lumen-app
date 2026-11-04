# SQLCipher's native library looks up fields and methods of these classes by
# name through JNI (for example SQLiteDatabase.mNativeHandle). Release
# shrinking renames or removes them, which crashes the app at launch with a
# NoSuchFieldError while the plugins register, so they must be kept as is.
-keep class net.sqlcipher.** { *; }
-keep class net.sqlcipher.database.** { *; }
