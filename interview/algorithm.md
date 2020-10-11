# algorithm 

## 排序算法

### 快速排序

```java
public class QuickSort {
    public void quickSort(int[] arr, int left, int right) {
        if (left < right) {
            int partition = partition(arr, left, right);
            quickSort(arr, left, partition - 1);
            quickSort(arr, partition + 1, right);
        }
    }
    private int partition(int[] arr, int left, int right) {
        int index = left + 1;
        for (int i = index; i <= right; i++) {
            if (arr[i] < arr[left]) {
                swap(arr, i, index);
                index += 1;
            }
        }
        swap(arr, left, index - 1);
        return index - 1;
    }
    private void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}
```

### 堆排序

```java
public class HeapSort {
    private void heapify(int[] arr, int i, int last) {
        int leftChild = i * 2 + 1;
        int rightChild = i * 2 + 2;
        int maxIndex = i;
        if (leftChild <= last && arr[leftChild] > arr[i]) maxIndex = leftChild;
        if (rightChild <= last && arr[rightChild] > arr[maxIndex]) maxIndex = rightChild;
        if (maxIndex != i) {
            swap(arr, i, maxIndex);
            this.heapify(arr, maxIndex, last);
        }
    }
    private void buildHeap(int[] arr) {
        int lastParent = (arr.length - 1 - 1) / 2;
        for(int i = lastParent; i >= 0; i--) {
            this.heapify(arr, i, arr.length - 1);
        }
    }
    private void heapSort(int[] arr) {
        this.buildHeap(arr);
        for(int i = arr.length - 1; i >= 0; i--) {
            swap(arr, 0, i);
            this.heapify(arr, 0, i - 1);
        }
    }
    private void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}
```

### 归并排序

```java
public class MergeSort {
    public int[] mergeSort(int[] arr) {
        if (arr.length < 2) return arr;
        int mid = arr.length / 2;
        int[] left = Arrays.copyOfRange(arr, 0, mid);
        int[] right = Arrays.copyOfRange(arr, mid, arr.length);
        return merge(mergeSort(left), mergeSort(right));
    }
    private int[] merge(int[] left, int[] right) {
        int[] res = new int[left.length + right.length];
        int index = 0;
        int i = 0;
        int j = 0;
        while (i < left.length && j < right.length) {
            if (left[i] <= right[j]) {
                res[index] = left[i];
                i += 1;
            } else {
                res[index] = right[j];
                j += 1;
            }
            index += 1;
        }
        while (i < left.length) {
            res[index] = left[i];
            i += 1;
            index += 1;
        }
        while (j < right.length) {
            res[index] = right[j];
            j += 1;
            index += 1;
        }
        return res;
    }
}
```

## 优先队列

```java

```

## LRU

### 双向链表 + HashMap

```java
public class LRU {
    private HashMap<Integer, Node> map;
    private DoubleList cache;
    private int cap;
    public LRU(int cap) {
        this.map = new HashMap<>();
        this.cache = new DoubleList();
        this.cap = cap;
    }
    public int get(int key) {
        Node node = map.get(key);
        cache.remove(node);
        cache.addLast(node);
        return node.value;
    }
    public void put(int key, int value) {
        Node node = new Node(key, value);
        if (cap == cache.size()) {
            Node remove = cache.removeFirst();
            map.remove(remove.key);
        }
        map.put(key, node)  ;
        cache.addLast(node);
    }
    public void remove(int key) {
        Node node = map.remove(key);
        cache.remove(node);
    }
}
class Node {
    int key;
    int value;
    Node next;
    Node pre;
    public Node(int key, int value) {
        this.key = key;
        this.value = value;
    }
}
class DoubleList {
    private Node dummyHead;
    private Node dummyTail;
    private int size;
    public DoubleList() {
        this.dummyHead = new Node(0, 0);
        this.dummyTail = new Node(0, 0);
        this.size = 0;
        dummyHead.next = dummyTail;
        dummyHead.pre = dummyTail;
        dummyTail.next = dummyHead;
        dummyTail.pre = dummyHead;
    }
    public void addLast(Node node) {
        node.next = dummyTail;
        node.pre = dummyTail.pre;
        dummyTail.pre.next = node;
        dummyTail.pre = node;
        size += 1;
    }
    public void remove(Node node) {
        node.pre.next = node.next;
        node.next.pre = node.pre;
        size -= 1;
    }
    public Node removeFirst() {
        Node last = dummyHead.next;
        remove(last);
        return last;
    }
    public int size() {
        return size;
    }
}
```

### LinkedHashMap

```java
public class LRU {
    private LinkedHashMap<Integer, Integer> cache;
    private int cap;
    public LRU_LinkedHashMap(int cap) {
        this.cache = new LinkedHashMap<>();
        this.cap = cap;
    }
    public int get(int key) {
        Integer value = cache.remove(key);
        cache.put(key, value);
        return value;
    }
    public void put(int key, int value) {
        if (cap == cache.size()) {
            Integer removeKey = cache.keySet().iterator().next();
            cache.remove(removeKey);
        }
        cache.put(key, value);
    }
}
```

## 二叉树非递归遍历

### 前序

```java
public void preorder(TreeNode root) {
    LinkedList<TreeNode> stack = new LinkedList<>();
    TreeNode cur = root;
    while (cur != null || !stack.isEmpty()) {
        while (cur != null) {
            System.out.println(cur.val);
            stack.addLast(cur);
            cur = cur.left;
        }
        cur = stack.removeLast();
        cur = cur.right;
    }
    return res;
}
```

### 中序

```java
public void inorder(TreeNode root) {
    LinkedList<TreeNode> stack = new LinkedList<>();
    TreeNode cur = root;
    while (cur != null || !stack.isEmpty()) {
        while (cur != null) {
            stack.addLast(cur);
            cur = cur.left;
        }
        cur = stack.removeLast();
        System.out.println(cur.val);
        cur = cur.right;
    }
    return res;
}
```

### 后序

```java
public void postorder(TreeNode root) {
    LinkedList<TreeNode> stack = new LinkedList<>();
    TreeNode cur = root;
    TreeNode last = null;
    while (cur != null || !stack.isEmpty()) {
        while (cur != null) {
            stack.addLast(cur);
            cur = cur.left;
        }
        cur = stack.getLast();
        if (cur.right == null || cur.right == last) {
            System.out.println(cur.val);
            stack.removeLast();
            last = cur;
            cur = null;
        } else cur = cur.right;
    }
    return res;
}
```

## Morris遍历

Morris遍历可以在O(n)的时间复杂度和O(1)的空间复杂度下完成二叉树的遍历，相较于递归或用栈模拟递归只需要O(1)的空间复杂度

从头节点开始记作当前节点cur
- 如果cur无左节点，cur向右移动(cur = cur.right)
- 如果cur有左节点，找到cur的左子树中的最右的节点，记作mostRight
  - 如果mostRight的右节点为null，则将mostRight的右节点指向cur，cur向左移动(cur = cur.left)
  - 如果mostRight的右节点指向cur，则将mostRight的右节点指向null，cur向右移动(cur = cur.right)

Morris遍历中对于没有左子树的节点只到达一次，对于有左子树的节点会到达两次

```java
public void mirros(TreeNode root) {
    if (root == null) return;
    TreeNode cur = root;
    TreeNode mostRight = null;
    while (cur != null) {
        mostRight = cur.left;
        if (mostRight != null) {
            while (mostRight.right != null && mostRight.right != cur) {
                mostRight = mostRight.right;
            }           
            if (mostRight.right == null) {
                mostRight.right = cur;
                cur = cur.left;
                continue;
            } else mostRight.right = null;
        }
        cur = cur.right;
    }
}
```

Morris实现前序遍历：没有左子树的直接打印，有左子树的第一次打印，第二次不打印

```java
public void mirrosPre(TreeNode root) {
    if (root == null) return;
    TreeNode cur = root;
    TreeNode mostRight = null;
    while (cur != null) {
        mostRight = cur.left;
        if (mostRight != null) {
            while (mostRight.right != null && mostRight.right != cur) {
                mostRight = mostRight.right;
            }           
            if (mostRight.right == null) {
                System.out.println(cur.val); 
                mostRight.right = cur;
                cur = cur.left;
                continue;
            } else mostRight.right = null;
        } else System.out.println(cur.val);
        cur = cur.right;
    }
}
```

Morris实现中序遍历：在cur = cur.right之前打印，即表明左子树的都打印过了

```java
public void mirrosIn(TreeNode root) {
    if (root == null) return;
    TreeNode cur = root;
    TreeNode mostRight = null;
    while (cur != null) {
        mostRight = cur.left;
        if (mostRight != null) {
            while (mostRight.right != null && mostRight.right != cur) {
                mostRight = mostRight.right;
            }           
            if (mostRight.right == null) {
                mostRight.right = cur;
                cur = cur.left;
                continue;
            } else mostRight.right = null;
        }
        System.out.println(cur.val);
        cur = cur.right;
    }
}
```

Morris实现后序遍历：在第一次遇到会到达两次的节点(即存在左子树的节点)就逆序其左子树的右边界，最后打印整棵树的右边界

```java
public void mirrosPost(TreeNode root) {
    if (root == null) return;
    TreeNode cur = root;
    TreeNode mostRight = null;
    while (cur != null) {
        mostRight = cur.left;
        if (mostRight != null) {
            while (mostRight.right != null && mostRight.right != cur) {
                mostRight = mostRight.right;
            }           
            if (mostRight.right == null) {
                mostRight.right = cur;
                cur = cur.left;
                continue;
            } else {
                printEdge(cur.left);
                mostRight.right = null;
            }
        }
        cur = cur.right;
    }
    printEdge(root);
}
private void printEdge(TreeNode node) {
    TreeNode tail = reverseEdge(node);
    TreeNode cur = tail;
    while (cur != null) {
        System.out.println(cur.val);
        cur = cur.right;
    }
    reverseEdge(tail);
}
private Node reverseEdge(TreeNode node) {
    TreeNode pre = null;
    while (node != null) {
        TreeNode temp = node.right;
        node.right = pre;
        pre = node;
        node = temp;
    }
    return pre;
}
```

## 二分查找实现平方根

```java
public double sqrt(double x, double precision) {
    double l = x > 1 ? 1 : x;
    double r = x > 1 ? x : 1;
    while (l <= r) {
        double m = r + (l - r) / 2.0;
        if (Math.abs(m * m - x) <= precision) return m;
        else if (m * m > x) r = m;
        else if (m * m < x) l = m;
    }
    return -1.0;
}
```
