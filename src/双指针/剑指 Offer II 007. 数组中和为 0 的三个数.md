#### 剑指 Offer II 007. 数组中和为 0 的三个数

给定一个包含 n 个整数的数组 nums，判断 nums 中是否存在三个元素 a ，b ，c ，使得 a + b + c = 0 ？请找出所有和为 0 且 不重复 的三元组。

**示例 1：**

```shell
输入：nums = [-1,0,1,2,-1,-4]
输出：[[-1,-1,2],[-1,0,1]]
```

**示例 2：**

```shell
输入：nums = []
输出：[]
```

**示例 3：**

```shell
输入：nums = [0]
输出：[]
```

**提示：**

- `0 <= nums.length <= 3000`
- `-105 <= nums[i] <= 105`

### 题解

**双指针**

核心思想一致 **我们可以把这个问题转化成俩数之和 先确定一个数 在剩下的数里找俩数之和** 并且由于有序 可以不借助Hash去掉重复 节省很多时间

```java
class Solution {
   public List<List<Integer>> threeSum(int[] nums) {
        List<List<Integer>> result = new ArrayList();
        // 数组为空 或者长度小于三 无效 直接返回
        if (nums == null || nums.length < 3) {
            return result;
        }

        Arrays.sort(nums);

        for (int i = 0; i < nums.length; i++) {
            // 三数相加等于0 最小的数一定小于等于0
            if (nums[i] > 0) {
                break;
            }
            // 和上次相同无意义
            if (i != 0 && nums[i] == nums[i - 1]) {
                continue;
            }

            int target = -nums[i];

            int left = i + 1;
            int right = nums.length - 1;
            while (left < right) {
                // 想办法找目标值
                int sum = nums[left] + nums[right];
                // 超过目标值  和一定变小 右边界移动
                if (sum > target) {
                    right--;
                    // 小于目标值  和一定变大 左边界移动
                } else if (sum < target) {
                    left++;
                    // 等于目标值 记录结果
                } else {
                    result.add(List.of(nums[i], nums[left], nums[right]));
                    // 避免重复 值相等时跳过
                    while (left < right && nums[left] == nums[++left]); 
                    while (left < right && nums[right] == nums[--right]);
                }
            }
        }
        return result;
    }
}
```

