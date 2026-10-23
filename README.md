<div align="center">

<img width="1600" height="480" alt="TH_DESK_GitHub_Banner (1)" src="https://github.com/user-attachments/assets/18f335cd-da99-430f-97e5-8c1ba43a48be" />


# 💻 TH_DESK — Remote Desktop Client
**โปรแกรมรีโมทเดสก์ท็อปความเร็วสูงแบบโอเพนซอร์ส เชื่อมต่อผ่านเซิร์ฟเวอร์ส่วนตัวและ DDNS ได้ทันที**  
*Fast, Secure, and Open-Source P2P Remote Desktop Client*

[![Platform](https://img.shields.io/badge/Platform-Windows%20(x64%20%2F%20x86)-0071FF?style=for-the-badge&logo=windows)](https://github.com/kuromineko/TH_DESK/releases)
[![Core](https://img.shields.io/badge/Built%20with-Rust%20%26%20Flutter-F74C00?style=for-the-badge&logo=rust)](https://github.com/kuromineko/TH_DESK)
[![License](https://img.shields.io/badge/License-AGPL--3.0-10B981?style=for-the-badge)](https://www.gnu.org/licenses/agpl-3.0.html)
[![Server Manager](https://img.shields.io/badge/Server%20Manager-TH__DESK__Server-A78BFA?style=for-the-badge&logo=github)](https://github.com/kuromineko/TH_DESK_Server)

</div>

---

## ✨ คุณสมบัติเด่น (Key Features)

* ⚡ **High-Performance P2P Remote Desktop:** รีโมทควบคุมหน้าจอความหน่วงต่ำ ภาพคมชัดลื่นไหล รองรับการรับ-ส่งไฟล์ คลิปบอร์ด และเสียงแบบเรียลไทม์
* 🔗 **ออกแบบให้ทำงานคู่กับ [TH_DESK Server Manager](https://github.com/kuromineko/TH_DESK_Server):** รองรับการเชื่อมต่อเข้าเซิร์ฟเวอร์ส่วนตัวผ่านโดเมน **DDNS** และการตั้งค่า Port Forwarding (แยกพอร์ตนอก/พอร์ตใน) ได้อย่างสมบูรณ์
* 📥 **Zero-Config Auto Setup (ไม่ต้องกรอก IP/Key เอง):** รองรับการดึงค่าเซิร์ฟเวอร์อัตโนมัติจากไฟล์ `TH_DESK2.toml` หรือสคริปต์ `Setup_TH_DESK_Client.bat` ที่ส่งออกมาจากตัวจัดการเซิร์ฟเวอร์
* 🔒 **End-to-End Encryption:** เข้ารหัสการเชื่อมต่อทุกเซสชันด้วยรหัสความปลอดภัย Public/Private Key (`ed25519`) ป้องกันการดักจับข้อมูลและจำกัดสิทธิ์เฉพาะผู้ที่มี Key ของเซิร์ฟเวอร์เท่านั้น
* 🆓 **100% Free & Open Source:** แจกจ่ายให้ใช้งานได้ฟรี ไม่จำกัดจำนวนเครื่อง ไม่จำกัดเวลาการเชื่อมต่อ และเปิดเผยซอร์สโค้ดทั้งหมดภายใต้สัญญาอนุญาต AGPL-3.0

---

## 🚀 วิธีใช้งานและเชื่อมต่อเซิร์ฟเวอร์ (Quick Start)

### วิธีที่ 1: ตั้งค่าอัตโนมัติคลิกเดียว (แนะนำ — ไม่ต้องพิมพ์ IP หรือ Key เอง)
1. ดาวน์โหลดโปรแกรม **`TH_DESK`** จากหน้า [Releases](https://github.com/kuromineko/TH_DESK/releases)
2. บนเครื่องแม่ข่ายที่เปิดโปรแกรม **[TH_DESK Server Manager](https://github.com/kuromineko/TH_DESK_Server)** ให้กดปุ่ม **"📥 ส่งออกไฟล์ลูกข่าย"**
3. นำไฟล์ **`Setup_TH_DESK_Client.bat`** ที่ได้ มาดับเบิลคลิกที่เครื่องลูกข่าย 1 ครั้ง ระบบจะฝังค่า DDNS, Port และ Public Key เข้าสู่ระบบให้อัตโนมัติ
4. เปิดโปรแกรม **TH_DESK** สถานะมุมล่างซ้ายจะขึ้นไฟสีเขียว **พร้อมใช้งาน (Ready)** ทันที

### วิธีที่ 2: กรอกค่าเซิร์ฟเวอร์ด้วยตัวเอง (Manual Setup)
1. เปิดโปรแกรม **TH_DESK** คลิกที่ปุ่มเมนู `⋮` (หรือ **การตั้งค่า / Settings**) -> เลือกแถบ **เครือข่าย (Network)**
2. กดปลดล็อกการตั้งค่า แล้วคลิกที่ **เซิร์ฟเวอร์ ID/Relay (ID/Relay Server)**
3. นำข้อมูลที่ได้จากโปรแกรม **TH_DESK Server** มาใส่ดังนี้:
   * **ID Server:** `ชื่อโดเมน-DDNS:OutPort` *(เช่น `your-ddns.thddns.net:4997`)*
   * **Relay Server:** `ชื่อโดเมน-DDNS:RelayOutPort` *(เช่น `your-ddns.thddns.net:4998`)*
   * **Key:** `รหัส Public Key จากหน้าจอโปรแกรม Server`
4. กด **ตกลง (OK)** เพื่อบันทึก

---

## 🛠️ การบิ้วด์ไฟล์ติดตั้งด้วยตัวเอง (Build from Source / GitHub Actions)

โปรเจกต์นี้รองรับการคอมไพล์อัตโนมัติผ่านระบบ **GitHub Actions**:
1. ไปที่แท็บ **Actions** บนหน้า GitHub Repository นี้
2. เลือกเวิร์กโฟลว์ที่ต้องการบิ้วด์:
   * **`Flutter Nightly Build`** — สำหรับคอมไพล์ตัวติดตั้งรุ่นมาตรฐาน (64-bit)
   * **`Build TH_DESK 32-bit (x86)`** — สำหรับคอมไพล์รุ่น Portable (32-bit รองรับ Windows ทุกเวอร์ชัน)
3. คลิกปุ่ม **Run workflow** และดาวน์โหลดไฟล์ `.exe` ที่คอมไพล์เสร็จแล้วได้จากหน้า **Releases** หรือ **Artifacts**

---

## 📦 ระบบที่เกี่ยวข้องในชุดเดียวกัน (Ecosystem)

| โปรเจกต์ (Repository) | รายละเอียด | ลิงก์ดาวน์โหลด / ซอร์สโค้ด |
| :--- | :--- | :---: |
| **💻 TH_DESK (Client)** | โปรแกรมรีโมทเดสก์ท็อปสำหรับเครื่องผู้ใช้งานและเครื่องปลายทาง | [kuromineko/TH_DESK](https://github.com/kuromineko/TH_DESK) |
| **🖥️ TH_DESK Server (x64)** | โปรแกรมจัดการเซิร์ฟเวอร์สำเร็จรูป (GUI) รองรับ DDNS, แยกพอร์ต IN/OUT และเปิด Firewall อัตโนมัติ | [kuromineko/TH_DESK_Server](https://github.com/kuromineko/TH_DESK_Server) |

---

## 📜 เครดิตและสัญญาอนุญาต (Credits & License)

* **ผู้พัฒนาและดูแลโปรเจกต์ (Developer & Maintainer):** [kuromineko](https://github.com/kuromineko)
* **ซอร์สโค้ดต้นฉบับ (Upstream Project):** โปรเจกต์นี้พัฒนาต่อยอด (Fork) มาจาก [RustDesk (rustdesk/rustdesk)](https://github.com/rustdesk/rustdesk) ขอขอบคุณทีมพัฒนา RustDesk สำหรับซอร์สโค้ดต้นฉบับที่ยอดเยี่ยม
* **สัญญาอนุญาต (License):** เผยแพร่ภายใต้สัญญาอนุญาตสาธารณะ **[GNU Affero General Public License v3.0 (AGPL-3.0)](https://www.gnu.org/licenses/agpl-3.0.html)** โดยเปิดเผยซอร์สโค้ดและแจกจ่ายให้ใช้งานได้ฟรี
