# pip的使用

## 配置pip源（清华）

### 临时使用

使用`-i`参数指定该package的下载源

```bash
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple PACKAGE
```

### 永久配置

```bash
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

## pip的更新

```python
python -m pip install --upgrade pip
```

## 查看pip版本

```python
pip --version
```

## 查看所有已安装的包

```python
pip list
```

## 查看单个包的信息

```python
pip show Package
```

## pip包安装

```python
pip install Package
```

## pip包更新

```python
pip install -U Package
```

## pip包卸载

```python
pip uninstall Package
```
