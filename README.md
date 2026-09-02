# AS-FrooshYar | فروشیار

فروشیار نرم‌افزار فروش، صندوق و مدیریت موجودی برای کسب‌وکارهای کوچک و متوسط است. پروژه با Flutter توسعه داده می‌شود و هسته آن Offline-first است؛ عملیات اصلی فروش و مدیریت داده برای کارکرد روزمره به اینترنت وابسته نیست.

## وضعیت فعلی

پروژه از یک POS متن‌باز مبتنی بر Flutter شخصی‌سازی شده و اکنون وارد مرحله جداسازی هویت، فارسی‌سازی و توسعه اختصاصی AS Team شده است.

### قابلیت‌های پایه موجود

- ثبت سفارش و فروش
- مدیریت کالا و دسته‌بندی
- مدیریت موجودی
- صندوق و محاسبات روزانه
- گزارش و نمودار
- چاپ رسید با چاپگرهای پشتیبانی‌شده
- انتقال و پشتیبان‌گیری داده
- دیتابیس محلی
- طراحی Responsive

## مشخصات پروژه

- نام فارسی: **فروشیار**
- Repository: `AS-FrooshYar`
- Android Application ID: `com.asteam.frooshyar`
- Developer: **AS Team Group**
- Support: `AS.Developers.Support@Gmail.Com`

## جهت توسعه

نسخه AS-FrooshYar برای بازار فارسی روی این موارد توسعه پیدا می‌کند:

- رابط فارسی و RTL
- تومان/ریال و فرمت سه‌رقمی قیمت
- تاریخ شمسی
- مشتریان و فاکتورهای فارسی
- تخفیف، مالیات و روش‌های پرداخت
- بارکد و مدیریت موجودی فروشگاهی
- Drawer استاندارد AS Team
- Backup/Restore مطمئن
- Migration دیتابیس و نصب آپدیت بدون حذف اطلاعات
- بررسی نسخه جدید داخل برنامه

نقشه راه کامل در [`docs/AS_FROOSHYAR_ROADMAP_FA.md`](docs/AS_FROOSHYAR_ROADMAP_FA.md) قرار دارد.

## ساختار فنی

- Flutter / Dart
- SQLite (`sqflite`) و ذخیره‌سازی محلی
- Provider برای State Management
- GoRouter برای Navigation
- پشتیبانی Android / iOS و ساختار چندسکویی Flutter

## Build

برای توسعه ابتدا Flutter SDK سازگار با نسخه مشخص‌شده در `pubspec.yaml` را نصب کنید و سپس:

```bash
flutter pub get
flutter run --flavor dev
```

برای Release باید keystore اختصاصی AS Team خارج از Git نگهداری شود و `android/key.properties` روی محیط Build تنظیم شود.

## مجوز و Attribution

این مخزن بر پایه پروژه متن‌باز `flutter-pos-system` توسعه یافته است و کد پایه تحت Apache License 2.0 قرار دارد. فایل `LICENSE` و اعلان‌های لازم مربوط به کد متن‌باز باید حفظ شوند. تغییر نام و توسعه اختصاصی AS-FrooshYar مالکیت یا شرایط مجوز کدهای ثالث را تغییر نمی‌دهد.
