#### 剑指 Offer 53 - I. 在排序数组中查找数字 I

统计一个数字在排序数组中出现的次数。

**示例 1:**

```java
输入: nums = [5,7,7,8,8,10], target = 8
输出: 2
```

**示例 2:**

```shell
输入: nums = [5,7,7,8,8,10], target = 6
输出: 0
```

**限制：**

0 <= 数组长度 <= 50000

### 题解

#### 方法一：二分查找

直观的思路肯定是从前往后遍历一遍。用两个变量记录第一次和最后一次遇见target 的下标，但这个方法的时间复杂度为 O(n)，没有利用到数组升序排列的条件。

由于数组已经排序，因此整个数组是**单调递增**的，我们可以利用二分法来加速查找的过程。

考虑target 在数组中出现的次数，其实我们要找的就是数组中「第一个等于 target 的位置」（记为 leftIdx）和「第一个大于 target 的位置减一」（记为rightIdx）。当 target 在数组中存在时，target 在数组中出现的次数为rightIdx−leftIdx+1。

二分查找中，寻找 leftIdx 即为在数组中寻找第一个大于等于target 的下标，寻找rightIdx 即为在数组中寻找第一个大于target 的下标，然后将下标减一。两者的判断条件不同，为了代码的复用，我们定义 binarySearch(nums, target, lower) 表示在 nums 数组中二分查找target 的位置，如果 lower 为true，则查找第一个大于等于 target 的下标，否则查找第一个大于target 的下标。

最后，因为 target 可能不存在数组中，因此我们需要重新校验我们得到的两个下标 leftIdx 和 rightIdx，看是否符合条件，如果符合条件就返回 rightIdx−leftIdx+1，不符合就返回 0。

```java
class Solution {
 public int search(int[] nums, int target) {

        int leftIndex = binarySearch(nums, target, true);
        int rightIndex = binarySearch(nums, target, false) - 1;
        if (leftIndex <= rightIndex && rightIndex <= nums.length - 1 && nums[leftIndex] == target && nums[rightIndex] == target) {
            return rightIndex - leftIndex + 1;
        }
        return 0;
    }

    public int binarySearch(int[] nums, int target, boolean lower) {
        int left = 0;
        int right = nums.length - 1;
        int ans = nums.length;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (nums[mid] > target || (lower && nums[mid] >= target)) {
                right = mid - 1;
                ans=mid;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }
}
```

