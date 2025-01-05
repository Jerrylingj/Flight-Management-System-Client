# 🌍 云途 - 前端仓库

[English Version](README.md) | [简体中文](README-zh.md)

---

<div align="center">
  <img src="./favicon.jpg" alt="Altair Logo" style="border-radius: 8px;"/>
</div>


---

## 🚀 **系统介绍**
**云途** 起源于中山大学软件工程学院初级实训课程的大作业，由 **[终端露台](https://github.com/Terminal-Terrace)** 团队开发。这是一个基于 **QML** 开发的前端项目，设计用于提供高效、直观的用户交互界面。系统支持 **用户端** 和 **管理员端** 功能，包括：

- **航班查询和筛选**。
- **订单管理**。
- **个人中心**。
- **旅游笔记展示**。

---

## 🖂 **项目结构**
```plaintext
├── components/              # 公共组件
├── views/                   # 功能页面
├── figures/                 # 静态资源
├── api/                     # 工具模块
├── storage/				 # 全局变量
├── Main.qml                 # 应用进入点
└── README.md                # 项目说明文档
```

---

## ✨ **功能**

### 用户端
- 🔎 **航班查询**：支持按时间、城市、价格筛选航班信息。
- 📋 **订单管理**：查看、筛选和管理订单，支持退正签。
- 🌟 **个人中心**：管理个人信息和收藏航班。
- 🗒 **旅游笔记**：发现并与旅游笔记交互。

### 管理员端
- 🛨 **航班管理**：添加、编辑和删除航班数据，支持实时更新。
- 👥 **用户管理**：查看和管理用户资料。

---

## ⚙️ **开发环境**

| 要求         | 详情    |
| ------------ | ------- |
| **Qt版本**   | 6.5.3   |
| **构建工具** | CMake   |
| **操作系统** | Windows |

---

## 🛠️ **开始使用**

### 1. 克隆项目
```bash
git clone git@github.com:Jerrylingj/Flight-Management-System-Client.git
```

### 2. 构建并运行
```bash
mkdir build && cd build
cmake ..
cmake --build .
```

---

## 🗋 **截图展示**
<div align="center">
  <img src="./figures/readme/cover-1.png" alt="Screenshot 1" width="45%"/>
  <img src="./figures/readme/cover-2.png" alt="Screenshot 2" width="45%"/>
</div>

<div align="center">
  <img src="./figures/readme/cover-3.png" alt="Screenshot 3" width="45%"/>
  <img src="./figures/readme/cover-4.png" alt="Screenshot 4" width="45%"/>
</div>

<div align="center">
  <img src="./figures/readme/cover-5.png" alt="Screenshot 5" width="45%"/>
  <img src="./figures/readme/cover-6.png" alt="Screenshot 6" width="45%"/>
</div>

<div align="center">
  <img src="./figures/readme/cover-7.png" alt="Screenshot 7" width="45%"/>
  <img src="./figures/readme/cover-8.png" alt="Screenshot 8" width="45%"/>
</div>

<div align="center">
  <img src="./figures/readme/cover-9.png" alt="Screenshot 9" width="45%"/>
  <img src="./figures/readme/cover-10.png" alt="Screenshot 10" width="45%"/>
</div>

<div align="center">
  <img src="./figures/readme/cover-11.png" alt="Screenshot 11" width="45%"/>
  <img src="./figures/readme/cover-12.png" alt="Screenshot 12" width="45%"/>
</div>

<div align="center">
  <img src="./figures/readme/cover-13.png" alt="Screenshot 13" width="45%"/>
  <img src="./figures/readme/cover-14.png" alt="Screenshot 14" width="45%"/>
</div>

<div align="center">
  <img src="./figures/readme/cover-15.png" alt="Screenshot 15" width="45%"/>
  <img src="./figures/readme/cover-16.png" alt="Screenshot 16" width="45%"/>
</div>

<div align="center">
  <img src="./figures/readme/cover-17.png" alt="Screenshot 17" width="45%"/>
  <img src="./figures/readme/cover-18.png" alt="Screenshot 18" width="45%"/>
</div>

<div align="center">
  <img src="./figures/readme/cover-19.png" alt="Screenshot 19" width="45%"/>
  <img src="./figures/readme/cover-20.png" alt="Screenshot 20" width="45%"/>
</div>

---

## 🤝 **贡献**

欢迎任何人为项目贡献！请按照以下步骤：
1. 分支项目。
2. 创建一个功能分支：`git checkout -b feature-name`。
3. 提交你的修改：`git commit -m "Add feature-name"`。
4. 推送分支：`git push origin feature-name`。
5. 创建一个拓展请求。

---

## 📞 **联系方式**

如有任何问题或建议，请联系：

- **Jerrylingj**：lingj28@mail2.sysu.edu.cn
- **water2027**：linshy76@mail2.sysu.edu.cn
- **math-zhuxy**：zhuxy255@mail2.sysu.edu.cn

- **YANGPuxyu**：yangpx26@mail2.sysu.edu.cn

---

## ⚡ **未来计划**

### 短期目标
- 完成前端 UI/UX 优化。
- 实现用户操作的详细错误处理。

### 长期目标
- 集成基于 AI 的航班推荐功能。
- 增加面向全球用户的多语言支持。
- 探索移动平台（Android/iOS）的兼容性。

---

<div align="center">
  <p>&copy; 2024 AltAir. All Rights Reserved.</p>
</div>
