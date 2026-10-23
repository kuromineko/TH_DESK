<div align="center">

<img width="1600" height="480" alt="TH_DESK_GitHub_Banner (1)" src="https://github.com/user-attachments/assets/080c15da-6073-4e84-99ea-7b9e108569bb" />


# 💻 TH_DESK — Remote Desktop Client
**โปรแกรมรีโมทเดสก์ท็อปความเร็วสูงแบบโอเพนซอร์ส เชื่อมต่อผ่านเซิร์ฟเวอร์ส่วนตัวและ DDNS ได้ทันที**  
*Fast, Secure, and Open-Source P2P Remote Desktop Client*

[![Platform](https://img.shields.io/badge/Platform-Windows%20(x64%20%2F%20x86)-0071FF?style=for-the-badge&logo=windows)](https://github.com/kuromineko/TH_DESK/releases)
[![Core](https://img.shields.io/badge/Built%20with-Rust%20%26%20Flutter-F74C00?style=for-the-badge&logo=rust)](https://github.com/kuromineko/TH_DESK)
[![License](https://img.shields.io/badge/License-AGPL--3.0-10B981?style=for-the-badge)](https://www.gnu.org/licenses/agpl-3.0.html)
[![Server Manager](https://img.shields.io/badge/Server%20Manager-TH__DESK__Server-A78BFA?style=for-the-badge&logo=github)](https://github.com/kuromineko/TH_DESK_Server)

**[🇹🇭 อ่านภาษาไทย](#-คุณสมบัติเด่น-key-features) | [🇬🇧 Read in English](#-english-documentation)**

</div>

---

## ✨ คุณสมบัติเด่น (Key Features)

* ⚡ **High-Performance P2P Remote Desktop:** รีโมทควบคุมหน้าจอความหน่วงต่ำ ภาพคมชัดลื่นไหล รองรับการรับ-ส่งไฟล์ คลิปบอร์ด และเสียงแบบเรียลไทม์
* 🔗 **ทำงานคู่กับ [TH_DESK Server Manager](https://github.com/kuromineko/TH_DESK_Server):** รองรับการเชื่อมต่อเข้าเซิร์ฟเวอร์ส่วนตัวผ่านโดเมน **DDNS** และการตั้งค่า Port Forwarding (แยกพอร์ตนอก/พอร์ตใน) ได้อย่างสมบูรณ์
* 📥 **Zero-Config Auto Setup (ไม่ต้องกรอก IP/Key เอง):** รองรับการดึงค่าเซิร์ฟเวอร์อัตโนมัติจากไฟล์ `TH_DESK2.toml` หรือสคริปต์ `Setup_TH_DESK_Client.bat` ที่ส่งออกมาจากตัวจัดการเซิร์ฟเวอร์
* 🔒 **End-to-End Encryption:** เข้ารหัสการเชื่อมต่อทุกเซสชันด้วยรหัสความปลอดภัย Public/Private Key (`ed25519`)
* 🆓 **100% Free & Open Source:** แจกจ่ายให้ใช้งานได้ฟรี ไม่จำกัดจำนวนเครื่อง ไม่จำกัดเวลาการเชื่อมต่อ และเปิดเผยซอร์สโค้ดทั้งหมดภายใต้สัญญาอนุญาต AGPL-3.0

---

## 🚀 วิธีใช้งานและเชื่อมต่อเซิร์ฟเวอร์ (Quick Start - TH)

### วิธีที่ 1: ตั้งค่าอัตโนมัติคลิกเดียว (แนะนำ — ไม่ต้องพิมพ์ IP หรือ Key เอง)
1. ดาวน์โหลดโปรแกรม **`TH_DESK`** จากหน้า [Releases](https://github.com/kuromineko/TH_DESK/releases)
2. บนเครื่องแม่ข่ายที่เปิดโปรแกรม **[TH_DESK Server Manager](https://github.com/kuromineko/TH_DESK_Server)** ให้กดปุ่ม **"📥 ส่งออกไฟล์ลูกข่าย"**
3. นำไฟล์ **`Setup_TH_DESK_Client.bat`** ที่ได้ มาดับเบิลคลิกที่เครื่องลูกข่าย 1 ครั้ง ระบบจะฝังค่า DDNS, Port และ Public Key เข้าสู่ระบบให้อัตโนมัติ
4. เปิดโปรแกรม **TH_DESK** สถานะมุมล่างซ้ายจะขึ้นไฟสีเขียว **พร้อมใช้งาน (Ready)** ทันที

### วิธีที่ 2: กรอกค่าเซิร์ฟเวอร์ด้วยตัวเอง (Manual Setup)
1. เปิดโปรแกรม **TH_DESK** คลิกที่ปุ่มเมนู `⋮` (การตั้งค่า / Settings) -> เลือกแถบ **เครือข่าย (Network)** -> **เซิร์ฟเวอร์ ID/Relay (ID/Relay Server)**
2. กรอกข้อมูลที่ได้จากโปรแกรม **TH_DESK Server**:
   * **ID Server:** `ชื่อโดเมน-DDNS:OutPort` *(เช่น `your-ddns.thddns.net:4997`)*
   * **Relay Server:** `ชื่อโดเมน-DDNS:RelayOutPort` *(เช่น `your-ddns.thddns.net:4998`)*
   * **Key:** `รหัส Public Key จากหน้าจอโปรแกรม Server`

---

# 🇬🇧 English Documentation

## ✨ Key Features

* ⚡ **Low-Latency P2P Remote Desktop:** Fast screen sharing, file transfer, clipboard sync, and audio streaming powered by Rust and Flutter.
* 🔗 **Seamless Integration with [TH_DESK Server Manager](https://github.com/kuromineko/TH_DESK_Server):** Designed to work effortlessly with self-hosted DDNS domains and asymmetric NAT port forwarding setups.
* 📥 **Zero-Config Client Deployment:** Supports automatic server configuration import via `TH_DESK2.toml` or the one-click `Setup_TH_DESK_Client.bat` script exported by the Server Manager.
* 🔒 **End-to-End Encryption:** Secured with `ed25519` public/private key cryptography.
* 🆓 **100% Free & Open Source:** Free for everyone with no device or time limits, distributed under the AGPL-3.0 license.

## 🚀 Quick Start (EN)

### Method 1: One-Click Zero-Config Setup (Recommended)
1. Download **`TH_DESK`** from the [Releases](https://github.com/kuromineko/TH_DESK/releases) page.
2. In **[TH_DESK Server Manager](https://github.com/kuromineko/TH_DESK_Server)**, click **"📥 Export Client File"**.
3. Run **`Setup_TH_DESK_Client.bat`** on the client PC to automatically configure the DDNS host, ports, and public key.
4. Launch **TH_DESK**—the status indicator at the bottom-left will immediately turn green (**Ready**).

### Method 2: Manual Configuration
1. Open **TH_DESK** -> click `⋮` (**Settings**) -> **Network** -> **ID/Relay Server**.
2. Enter the connection parameters from your **TH_DESK Server**:
   * **ID Server:** `your-ddns-domain:OutPort` *(e.g., `your-ddns.thddns.net:4997`)*
   * **Relay Server:** `your-ddns-domain:RelayOutPort` *(e.g., `your-ddns.thddns.net:4998`)*
   * **Key:** `Your Server Public Key`

---

## 📦 Ecosystem Repositories

| Repository | Description | Link |
| :--- | :--- | :---: |
| **💻 TH_DESK (Client)** | Remote Desktop Client for operators and end-users | [kuromineko/TH_DESK](https://github.com/kuromineko/TH_DESK) |
| **🖥️ TH_DESK Server (x64)** | GUI Server Manager with DDNS, IN/Out Port mapping & Auto Firewall | [kuromineko/TH_DESK_Server](https://github.com/kuromineko/TH_DESK_Server) |

---

## 📜 เครดิตและสัญญาอนุญาต (Credits & License)

* **Developer & Maintainer:** [kuromineko](https://github.com/kuromineko)
* **Upstream Project:** Derived (Forked) from the open-source [RustDesk (rustdesk/rustdesk)](https://github.com/rustdesk/rustdesk) project. Special thanks to the RustDesk team and contributors.
* **License:** Distributed under the **[GNU Affero General Public License v3.0 (AGPL-3.0)](https://www.gnu.org/licenses/agpl-3.0.html)**.
