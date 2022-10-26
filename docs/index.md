# 浙江大学22年秋系统贯通二实验

本[仓库](http://git.zju.edu.cn/zju-sys/sys2lab-22fall-stu/)是浙江大学22年秋**系统贯通二**课程的教学仓库，包含所有实验文档和公开代码。仓库目录结构：

```bash
├── README.md
├── docs/       # 实验文档   
├── mkdocs.yml
└── src/        # 公开代码
```

实验文档已经部署在了[zju-git pages](http://zju-sys.pages.zjusct.io/sys2lab-22fall-stu/)上，方便大家阅读。


## 本地渲染文档

文档采用了 [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) 工具构建和部署。如果想在本地渲染：

```bash
$ pip3 install mkdocs-material                      # 安装 mkdocs-material
$ git clone http://git.zju.edu.cn/zju-sys/sys2lab-22fall-stu/ # clone 本 repo
$ mkdocs serve                                      # 本地渲染
INFO     -  Building documentation...
INFO     -  Cleaning site directory
...
INFO     -  [11:00:57] Serving on http://127.0.0.1:8000/sys2lab-22fall/
```
