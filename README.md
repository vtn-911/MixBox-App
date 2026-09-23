# 📚 MixBox App

**MixBox** là ứng dụng học tập và quản lý tài liệu được phát triển bằng **Flutter/Dart**, hỗ trợ
người dùng tìm kiếm, xem, lưu trữ và quản lý tài liệu học tập dưới dạng PDF.

Ứng dụng được xây dựng với mục tiêu cung cấp một giao diện học tập đơn giản, thuận tiện trên thiết
bị di động và có khả năng kết nối với hệ thống Backend thông qua RESTful API.

---

## ✨ Tính năng

### 🔐 Xác thực người dùng

* Đăng ký tài khoản.
* Đăng nhập bằng email và mật khẩu.
* Lưu thông tin phiên đăng nhập.
* Sử dụng JWT để xác thực request đến Backend.
* Bảo vệ các màn hình yêu cầu đăng nhập.

### 📄 Quản lý tài liệu

* Hiển thị danh sách tài liệu học tập.
* Xem thông tin chi tiết tài liệu.
* Xem trực tiếp file PDF trên ứng dụng.
* Tìm kiếm tài liệu.
* Lọc tài liệu theo danh mục.
* Upload tài liệu PDF.
* Tự động xác định số trang của tài liệu PDF.
* Hiển thị thông tin như tiêu đề, danh mục, người đăng và số trang.

### 📁 Quản lý thư mục

* Xem danh sách thư mục cá nhân.
* Xem các tài liệu bên trong thư mục.
* Quản lý và truy cập tài liệu theo từng thư mục.

### 👤 Quản lý người dùng

* Hiển thị thông tin tài khoản.
* Quản lý thông tin người dùng.
* Chia sẻ trạng thái người dùng giữa các màn hình thông qua Provider.

### 📷 Scanner

* Cung cấp màn hình Scanner cho chức năng xử lý tài liệu.
* Chức năng Scanner đang được tiếp tục phát triển.

---

## 🛠️ Công nghệ sử dụng

| Công nghệ                 | Mục đích                        |
|---------------------------|---------------------------------|
| **Flutter**               | Xây dựng giao diện ứng dụng     |
| **Dart**                  | Ngôn ngữ lập trình              |
| **RESTful API**           | Giao tiếp với Backend           |
| **JWT**                   | Xác thực người dùng             |
| **SharedPreferences**     | Lưu trữ dữ liệu phiên đăng nhập |
| **Provider**              | Quản lý và chia sẻ trạng thái   |
| **HTTP**                  | Gửi request đến Backend         |
| **File Picker**           | Chọn file từ thiết bị           |
| **Syncfusion PDF Viewer** | Hiển thị và đọc tài liệu PDF    |

---

## 🏗️ Kiến trúc ứng dụng

Ứng dụng được tổ chức theo hướng tách biệt giữa **UI, dữ liệu, trạng thái và tầng giao tiếp API**.

```text
UI / Screens
     │
     ▼
Providers
     │
     ▼
Services
     │
     ▼
RESTful API
     │
     ▼
Backend
```

### Các thành phần chính

* **Screens:** Chứa giao diện và luồng tương tác của người dùng.
* **Models:** Định nghĩa các model dữ liệu được sử dụng trong ứng dụng.
* **Providers:** Quản lý và chia sẻ state giữa các màn hình.
* **Services:** Xử lý giao tiếp với Backend API.
* **Utils:** Chứa các tiện ích dùng chung.
* **Widgets:** Chứa các component UI có thể tái sử dụng.

---

## 📂 Cấu trúc thư mục

```text
lib/
├── main.dart
│
├── models/
│   ├── categoriesModel.dart
│   ├── documents_model.dart
│   ├── document_detail.dart
│   ├── document_page.dart
│   ├── dropdown_item_model.dart
│   ├── folder_documents.dart
│   ├── folder_model.dart
│   ├── recent_documents.dart
│   ├── section_quickaction.dart
│   └── user_model.dart
│
├── providers/
│   ├── folder_provider.dart
│   └── user_provider.dart
│
├── screens/
│   ├── document_detail_screen.dart
│   ├── folderdetail_screen.dart
│   ├── homescreen.dart
│   ├── myfolder_screen.dart
│   ├── scanner_screen.dart
│   ├── signin_screen.dart
│   ├── signup_screen.dart
│   ├── studyscreen.dart
│   ├── uploaddocument_screen.dart
│   └── user_screen.dart
│
├── service/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── categories_service.dart
│   ├── document_service.dart
│   └── folder_service.dart
│
├── utils/
│   └── auth_guard.dart
│
└── widgets/
    └── forminput_document.dart

test/
└── widget_test.dart
```

---

## 🔌 API Service

Ứng dụng sử dụng một lớp `ApiService` dùng chung để xử lý các HTTP request đến Backend.

Các phương thức được sử dụng gồm:

```text
GET
POST
PUT
DELETE
Multipart Request
```

`ApiService` chịu trách nhiệm:

* Xây dựng URL API.
* Gửi HTTP request.
* Thêm JWT vào `Authorization Header`.
* Xử lý response từ Backend.
* Hỗ trợ upload file thông qua multipart request.

Các service chuyên biệt sử dụng `ApiService` để giao tiếp với từng nhóm API:

```text
AuthService
     │
     ├── Đăng nhập
     └── Đăng ký

DocumentService
     │
     ├── Danh sách tài liệu
     ├── Tìm kiếm
     ├── Chi tiết
     └── Upload

FolderService
     │
     ├── Danh sách folder
     └── Tài liệu trong folder

CategoriesService
     │
     └── Danh sách category
```

---

## 🔐 Authentication

Sau khi người dùng đăng nhập thành công, ứng dụng nhận thông tin người dùng và JWT từ Backend.

JWT được lưu trữ để sử dụng cho những request API tiếp theo.

Các API yêu cầu xác thực sẽ gửi token thông qua HTTP Header:

```http
Authorization: Bearer <token>
```

Ứng dụng cũng sử dụng `AuthGuard` để kiểm tra trạng thái đăng nhập trước khi cho phép người dùng
truy cập các màn hình yêu cầu xác thực.

---

## 📄 Hiển thị PDF

MixBox hỗ trợ đọc trực tiếp tài liệu PDF trên ứng dụng mà không cần chuyển PDF thành các hình ảnh
riêng biệt.

Luồng xử lý:

```text
Người dùng chọn tài liệu
        ↓
Backend trả về thông tin/file PDF
        ↓
Flutter nhận URL PDF
        ↓
PDF Viewer
        ↓
Người dùng đọc tài liệu
```

PDF Viewer hỗ trợ các thao tác cơ bản như:

* Cuộn tài liệu.
* Phóng to / thu nhỏ.
* Điều hướng trong tài liệu.

---

## ☁️ Lưu trữ tài liệu

Các file tài liệu được upload thông qua Backend và được lưu trữ trên **Cloudflare R2**.

Luồng upload:

```text
Flutter App
    │
    │ Multipart Request
    ▼
Backend API
    │
    ▼
Cloudflare R2
    │
    ▼
File PDF
```

Ứng dụng Flutter không trực tiếp quản lý thông tin xác thực của Cloudflare R2 mà giao tiếp thông qua
Backend API.

---

## 🚀 Cài đặt và chạy project

### 1. Clone repository

```bash
git clone <repository-url>
cd <project-folder>
```

### 2. Cài đặt dependencies

```bash
flutter pub get
```

### 3. Kiểm tra môi trường Flutter

```bash
flutter doctor
```

### 4. Chạy ứng dụng

```bash
flutter run
```

Hoặc chạy trên thiết bị/emulator cụ thể:

```bash
flutter devices
```

Sau đó:

```bash
flutter run -d <device-id>
```

---

## ⚙️ Cấu hình API

Trước khi chạy ứng dụng, cần đảm bảo `baseUrl` trong `ApiService` trỏ đến Backend đang hoạt động.

Ví dụ khi chạy Backend trên máy local và sử dụng Android Emulator:

```dart

static const String baseUrl = 'http://10.0.2.2:3000';
```

> `10.0.2.2` được Android Emulator sử dụng để truy cập `localhost` của máy tính.

---

## 🧪 Kiểm thử

Project hiện có cấu trúc test Flutter trong thư mục:

```text
test/
└── widget_test.dart
```

Có thể chạy test bằng:

```bash
flutter test
```

---

## 🔮 Định hướng phát triển

Một số chức năng dự kiến tiếp tục phát triển:

* [ ] Hoàn thiện Scanner.
* [ ] OCR tài liệu từ hình ảnh.
* [ ] Chỉnh sửa nội dung sau khi OCR.
* [ ] Xuất tài liệu sang Word/PDF.
* [ ] Tạo Quiz từ tài liệu.
* [ ] Lưu và quản lý tài liệu yêu thích.
* [ ] Cải thiện trải nghiệm đọc PDF.
* [ ] Bổ sung thêm các chức năng học tập.

---

## 👩‍💻 Thông tin dự án

**Tên dự án:** MixBox
**Nền tảng:** Flutter / Android
**Ngôn ngữ:** Dart
**Loại dự án:** Ứng dụng học tập và quản lý tài liệu

---

## 📌 Ghi chú

MixBox được phát triển trong quá trình học tập và thực hành phát triển ứng dụng Flutter, RESTful
API, xác thực người dùng, quản lý state và lưu trữ file trên cloud.

Dự án tập trung vào việc áp dụng kiến thức lập trình vào một sản phẩm thực tế, đồng thời từng bước
hoàn thiện kiến trúc và trải nghiệm người dùng.
