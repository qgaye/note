# algorithm 

## 排序算法

### 快排

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
                Swap.swap(arr, i, index);
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

### 堆排

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
        map.put(key, node);
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
