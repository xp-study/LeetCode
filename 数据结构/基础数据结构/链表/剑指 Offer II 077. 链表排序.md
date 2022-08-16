#### 剑指 Offer II 077. 链表排序

给定链表的头结点 `head` ，请将其按 **升序** 排列并返回 **排序后的链表** 。

**示例 1：**

![img](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/数据结构/基础数据结构/链表/images/链表排序/1.jpg)

```shell
输入：head = [4,2,1,3]
输出：[1,2,3,4]
```

**示例 2：**

![img](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/数据结构/基础数据结构/链表/images/链表排序/2.jpg)

```shell
输入：head = [-1,5,3,4,0]
输出：[-1,0,3,4,5]
```

**示例 3：**

```shell
输入：head = []
输出：[]
```

**提示：**

- 链表中节点的数目在范围 `[0, 5 * 104]` 内
- `-105 <= Node.val <= 105`

 **进阶：**你可以在 `O(n log n)` 时间复杂度和常数级空间复杂度下，对链表进行排序吗？

### 题解

### **A 思考过程**

由时间复杂度可以联想到**归并排序**.

- 对**数组**做归并排序需要的空间复杂度为O(n)-->新开辟数组O(n)+递归调用函数O(logn);

* 对链表做归并排序可以通过修改引用来更改节点位置，因此不需要向数组一样开辟额外的O(n)空间，但是只要是递归就需要消耗log(n)的空间复杂度，要达到O(1)空间复杂度的目标，得使用迭代法。

**因此对于链表进行排序有两种方案：**

（1）递归实现归并排序（空间复杂度不符合要求）
（2）迭代实现归并排序

### B 关键技巧

**(a) 技巧一：通过快慢指针找到链表中点**

需要确定链表的中点以进行两路归并。可以通过快慢指针的方法。快指针每次走两步，慢指针每次走一步。遍历完链表时，慢指针停留的位置就在链表的中点。

以下两种找中点的方式都可以

方法一:

![image-20210812083838088](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/数据结构/基础数据结构/链表/images/链表排序/3.jpg)

```java
    ListNode slow = head;
    ListNode fast = head.next; 
    
    while(fast!=null && fast.next!=null){ 
        slow = slow.next; //慢指针走一步
        fast = fast.next.next; //快指针走两步
    }
    ListNode rightHead = slow.next; //链表第二部分的头节点
    slow.next = null; //cut 链表
```

方法二:

![image-20210812083947481](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/数据结构/基础数据结构/链表/images/链表排序/4.jpg)

```java
 	ListNode slow = head; 
    ListNode fast = head; 
    ListNode pre = slow; //前驱指针
    while(fast!=null && fast.next!=null){ 
        pre = slow;
        slow = slow.next; //慢指针走一步
        fast = fast.next.next; //快指针走两步
    }
    ListNode rightHead = slow; //链表第二部分的头节点
    pre.next = null; //cut 链表
```

**（b) 技巧二：断链操作**

`split(l,n)` 即切掉链表l的前n个节点，并返回后半部分的链表头。

比如原来链表是`dummy->1->2->4->3->NULL`

`split(l,2)`的操作造成：

```shell
dummy->1->2->NULL
4->3->NULL
```

返回4这个后半部分这个链表头～

```java
    public ListNode split(ListNode head, int step) {
        // 断链部分,返回第二部分链表头
        if (head == null) {
            return null;
        }
        ListNode cur = head;
        for (int i = 1; i < step && cur.next != null; i++) {
            cur = cur.next;
        }
        ListNode right = cur.next;
        cur.next = null;
        return right;
    }

```

**(c) 技巧三：合并两个有序链表**

```java
    public ListNode merge(ListNode left, ListNode right) {
        ListNode dummyNode = new ListNode(0);
        ListNode p = dummyNode;

        while (left != null && right != null) {
            if (left.val <= right.val) {
                p.next = left;
                left = left.next;
            } else {
                p.next = right;
                right = right.next;
            }
            p = p.next;
        }

        p.next = left == null ? right : left;

        return dummyNode.next;
    }
```

**(d) 迭代法归并过程：**

![image-20210812085018899](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/数据结构/基础数据结构/链表/images/链表排序/5.jpg)

**代码**

```java
    // 递归
	public ListNode sortList(ListNode head) {
        if (head == null || head.next == null) {
            return head;
        }
		// 慢指针
        ListNode slow = head;
        // 快指针
        ListNode fast = head.next;
        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
        }
        // 链表第二部分的头节点
        ListNode rightHead = slow.next;
        slow.next = null;
        
        // 递归排序前一段链表
        ListNode left = sortList(head);
        // 递归排序后一段链表
        ListNode right = sortList(rightHead);
        // 合并排序好的两端链表
        return merge(left, right);
    }

	// 迭代
    public ListNode sortList1(ListNode head) {
        int length = getLength(head);
        ListNode dummy = new ListNode(-1);
        dummy.next = head;

        // 依次将链表分成1块,2块,4块,每一次补偿
        for (int step = 1; step < length; step *= 2) {
            // 每次变换步长,pre指针和cur指针都初始化在表头
            ListNode pre = dummy;
            ListNode cur = dummy.next;
            while (cur != null) {
               // 第一部分表头(第二次循环后,cur为剩余部分头,不断往后把链表按照步长step分成一块一块)
                ListNode h1 = cur;
                // 第二部分头
                ListNode h2 = split(h1, step);
                cur = split(h2, step);
                ListNode temp = merge(h1, h2);
                pre.next = temp;
                while (pre.next != null) {
                    pre = pre.next;
                }
            }
        }
        return dummy.next;
    }

    public int getLength(ListNode head) {
        // 获取链表长度
        int count = 0;
        while (head != null) {
            count++;
            head = head.next;
        }
        return count;
    }

    public ListNode split(ListNode head, int step) {
        // 断链部分,返回第二部分链表头
        if (head == null) {
            return null;
        }
        ListNode cur = head;
        for (int i = 1; i < step && cur.next != null; i++) {
            cur = cur.next;
        }
        ListNode right = cur.next;
        cur.next = null;
        return right;
    }

	// 合并两个有序链表
    public ListNode merge(ListNode left, ListNode right) {
        ListNode dummyNode = new ListNode(0);
        ListNode p = dummyNode;

        while (left != null && right != null) {
            if (left.val <= right.val) {
                p.next = left;
                left = left.next;
            } else {
                p.next = right;
                right = right.next;
            }
            p = p.next;
        }

        p.next = left == null ? right : left;

        return dummyNode.next;
    }
```

