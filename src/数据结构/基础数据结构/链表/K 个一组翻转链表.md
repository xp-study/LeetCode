# K 个一组翻转链表

给你一个链表，每 k 个节点一组进行翻转，请你返回翻转后的链表。

k 是一个正整数，它的值小于或等于链表的长度。

如果节点总数不是 k 的整数倍，那么请将最后剩余的节点保持原有顺序。

**示例：**

```text
给你这个链表：1->2->3->4->5
当 k = 2 时，应当返回: 2->1->4->3->5
当 k = 3 时，应当返回: 3->2->1->4->5
```

**思路：**

* 1 考虑本题的前提是知道如何翻转整个链表
* 2 本题的实际情况是K个一组翻转链表，所以在翻转链表后需要将其与前面的节点连接在一起
* 3 将翻转后的链表与前面的节点连接在一起需要使用的前驱节点与后驱节点
* 4 初始的前驱节点使用dummy节点代替，后驱节点遍历连接n个长度，先找到tail节点，tail.next节点为后驱节点
* 5 当前的前驱节点的下一个节点为翻转一组链表后反回的链表头
* 6 翻转完一组链表后，当前节点成为尾节点，此时当前节点的next指针需要指向后驱节点
* 7 变换前驱节点与后驱节点，前驱节点为当前节点，当前节点为后驱节点

**代码：**

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public ListNode reverseKGroup(ListNode head, int k) {
        
        ListNode dummy   = new ListNode(0);
        dummy.next=head;
        ListNode pre = dummy;
        ListNode cur = head;
        
        while(cur!=null){
            ListNode tail = cur;
            for(int i=1;i<k&&tail!=null;i++){
                tail=tail.next;
            }
            if (tail==null){
                break;
            }
            ListNode successor = tail.next;
            tail.next=null;
            pre.next=reverse(cur);
            cur.next=successor;

            // 指针的变换要小心
            pre=cur;
            cur=successor;
        }
        return dummy.next;
    }

    // 翻转链表
    public ListNode reverse(ListNode head){
        ListNode pre =null;
        ListNode cur =head;
        ListNode next;    
        while(cur!=null){
            next=cur.next;
            cur.next=pre;
            pre=cur;
            cur=next;
        }
        return pre;
    }
}
```

