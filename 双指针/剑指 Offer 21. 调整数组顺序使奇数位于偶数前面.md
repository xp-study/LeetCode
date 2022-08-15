#### 剑指 Offer 21. 调整数组顺序使奇数位于偶数前面

输入一个整数数组，实现一个函数来调整该数组中数字的顺序，使得所有奇数位于数组的前半部分，所有偶数位于数组的后半部分。

**示例：**

```shell
输入：nums = [1,2,3,4]
输出：[1,3,2,4] 
注：[3,1,2,4] 也是正确的答案之一。
```

**提示：**

1. `0 <= nums.length <= 50000`
2. `1 <= nums[i] <= 10000`

### 题解

#### 首尾双指针

* 定义头指针 leftl，尾指针 right.
* left 一直往右移，直到它指向的值为偶数
* right 一直往左移， 直到它指向的值为奇数
* 交换 nums[left] 和 nums[right] .
* 重复上述操作，直到 left == right .

![img](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/双指针/images/调整数组顺序使奇数位于偶数前面/1.gif)

#### 快慢双指针

- 定义快慢双指针 fast 和 low，fast在前， low 在后 .
- fast 的作用是向前搜索奇数位置，low 的作用是指向下一个奇数应当存放的位置
- fast向前移动，当它搜索到奇数时，将它和 nums[low] 交换，此时 low 向前移动一个位置 
- 重复上述操作，直到 fast 指向数组末尾 .

![img](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/双指针/images/调整数组顺序使奇数位于偶数前面/2.gif)

```java
class Solution {
    // 快慢指针
    public int[] exchange(int[] nums) {
        int low = 0;
        int fast = 0;
        while (fast < nums.length) {
            if ((nums[fast] & 1) == 1) {
                swap(nums, low, fast);
                low++;
            }
            fast++;
        }
        return nums;
    }

    // 首尾双指针
    public int[] exchange1(int[] nums) {
        int left = 0;
        int right = nums.length - 1;
        while (left < right) {
            if ((nums[left] & 1) != 0) {
                left++;
                continue;
            }

            if ((nums[right] & 1) != 1) {
                right--;
                continue;
            }
            swap(nums, left, right);
        }
        return nums;
    }


    public void swap(int[] nums, int i, int j) {
        if (i==j){
            return;
        }
        nums[i] = nums[i] ^ nums[j];
        nums[j] = nums[i] ^ nums[j];
        nums[i] = nums[i] ^ nums[j];
    }
}
```

