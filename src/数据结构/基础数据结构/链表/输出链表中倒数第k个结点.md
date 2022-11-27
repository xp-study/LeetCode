# 输出链表中倒数第k个结点

题目：输入一个链表，输出该链表中倒数第k个结点

思路1 传统法得到链表长度L，再从头遍历到L-k个

思路2 快慢指针，慢指针距离快指针始终k，当快指针到最后的null时候，输出慢指针

```java
public class Solution {
    public ListNode FindKthToTail(ListNode head,int k) {
        //快慢指针
        ListNode fast = head;
        ListNode slow = head;
        for(int i = 0; i < k; i++){
            if(fast == null){
                return null;
            }       
            fast = fast.next;
        }
        while(fast != null){
            fast = fast.next;
            slow = slow.next;
        }
        return slow;
    }
}
```

