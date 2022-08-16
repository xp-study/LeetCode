# 环形链表 II

#### Floyd 算法

**想法**

当然一个跑得快的人和一个跑得慢的人在一个圆形的赛道上赛跑，会发生什么？在某一个时刻，跑得快的人一定会从后面赶上跑得慢的人。

**算法**

Floyd 的算法被划分成两个不同的 *阶段* 。在第一阶段，找出列表中是否有环，如果没有环，可以直接返回 `null` 并退出。否则，用 `相遇节点` 来找到环的入口。

*阶段 1*

这里我们初始化两个指针 - 快指针和慢指针。我们每次移动慢指针一步、快指针两步，直到快指针无法继续往前移动。如果在某次移动后，快慢指针指向了同一个节点，我们就返回它。否则，我们继续，直到 while 循环终止且没有返回任何节点，这种情况说明没有成环，我们返回 null 。

*阶段 2*

给定阶段 1 找到的相遇点，阶段 2 将找到环的入口。首先我们初始化额外的两个指针： ptr1 ，指向链表的头， ptr2 指向相遇点。然后，我们每次将它们往前移动一步，直到它们相遇，它们相遇的点就是环的入口，返回这个节点。

下面的图将更好的帮助理解和证明这个方法的正确性。

<video id="video" controls="" preload="none">
    <source id="mp4" src="http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/数据结构/基础数据结构/链表/images/环形链表II/环形链表II.mp4" type="video/mp4">
</video>


![环形链表II](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/数据结构/基础数据结构/链表/images/环形链表II/环形链表II1.jpg)

我们利用已知的条件：慢指针移动 1 步，快指针移动 2 步，来说明它们相遇在环的入口处。（下面证明中的 tortoise 表示慢指针，hare 表示快指针）

![环形链表II](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/数据结构/基础数据结构/链表/images/环形链表II/环形链表II2.jpg)

因为 F=b，指针从 h 点出发和从链表的头出发，最后会遍历相同数目的节点后在环的入口处相遇。

```java
public class Solution {
    private ListNode getIntersect(ListNode head) {
        ListNode tortoise = head;
        ListNode hare = head;

        // A fast pointer will either loop around a cycle and meet the slow
        // pointer or reach the `null` at the end of a non-cyclic list.
        while (hare != null && hare.next != null) {
            tortoise = tortoise.next;
            hare = hare.next.next;
            if (tortoise == hare) {
                return tortoise;
            }
        }

        return null;
}

    public ListNode detectCycle(ListNode head) {
        if (head == null) {
            return null;
        }

        // If there is a cycle, the fast/slow pointers will intersect at some
        // node. Otherwise, there is no cycle, so we cannot find an e***ance to
        // a cycle.
        ListNode intersect = getIntersect(head);
        if (intersect == null) {
            return null;
        }

        // To find the e***ance to the cycle, we have two pointers traverse at
        // the same speed -- one from the front of the list, and the other from
        // the point of intersection.
        ListNode ptr1 = head;
        ListNode ptr2 = intersect;
        while (ptr1 != ptr2) {
            ptr1 = ptr1.next;
            ptr2 = ptr2.next;
        }

        return ptr1;
    }
}
```

