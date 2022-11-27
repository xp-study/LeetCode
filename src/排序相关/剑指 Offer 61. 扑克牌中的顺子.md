#### 剑指 Offer 61. 扑克牌中的顺子

从扑克牌中随机抽5张牌，判断是不是一个顺子，即这5张牌是不是连续的。2～10为数字本身，A为1，J为11，Q为12，K为13，而大、小王为 0 ，可以看成任意数字。A 不能视为 14。

**示例 1:**

```shell
输入: [1,2,3,4,5]
输出: True
```

**示例 2:**

```shell
输入: [0,0,1,2,5]
输出: True
```

**限制：**

数组长度为 5 

数组的数取值为 [0, 13] .

### 题解

#### 方法一： 集合 Set + 遍历

* 遍历五张牌，遇到大小王（即 0 ）直接跳过
* 判别重复： 利用 Set 实现遍历判重， Set 的查找方法的时间复杂度为 O(1) ；
* 获取最大 / 最小的牌： 借助辅助变量 ma 和 mi ，遍历统计即可。

```java
class Solution {
    public boolean isStraight(int[] nums) {
        Set<Integer> repeat = new HashSet<>();
        int max = 0, min = 14;
        for(int num : nums) {
            if(num == 0) continue; // 跳过大小王
            max = Math.max(max, num); // 最大牌
            min = Math.min(min, num); // 最小牌
            if(repeat.contains(num)) return false; // 若有重复，提前返回 false
            repeat.add(num); // 添加此牌至 Set
        }
        return max - min < 5; // 最大牌 - 最小牌 < 5 则可构成顺子
    }
}
```

#### 方法二：排序 + 遍历

* 先对数组执行排序。
* 判别重复： 排序数组中的相同元素位置相邻，因此可通过遍历数组，判断 nums[i] = nums[i + 1]是否成立来判重。
* 获取最大 / 最小的牌： 排序后，数组末位元素 nums[4] 为最大牌；元素 nums[joker] 为最小牌，其中 joker为大小王的数量。

```java
class Solution {
    public boolean isStraight(int[] nums) {
        int joker = 0;
        Arrays.sort(nums); // 数组排序
        for(int i = 0; i < 4; i++) {
            if(nums[i] == 0) joker++; // 统计大小王数量
            else if(nums[i] == nums[i + 1]) return false; // 若有重复，提前返回 false
        }
        return nums[4] - nums[joker] < 5; // 最大牌 - 最小牌 < 5 则可构成顺子
    }
}
```

