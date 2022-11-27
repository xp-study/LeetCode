#### LCP 18. 早餐组合

小扣在秋日市集选择了一家早餐摊位，一维整型数组 staple 中记录了每种主食的价格，一维整型数组 drinks 中记录了每种饮料的价格。小扣的计划选择一份主食和一款饮料，且花费不超过 x 元。请返回小扣共有多少种购买方案。

注意：答案需要以 `1e9 + 7 (1000000007)` 为底取模，如：计算初始结果为：`1000000008`，请返回 `1`

**示例 1：**

> 输入：staple = [10,20,5], drinks = [5,5,2], x = 15
>
> 输出：6
>
> 解释：小扣有 6 种购买方案，所选主食与所选饮料在数组中对应的下标分别是：
> 第 1 种方案：staple[0] + drinks[0] = 10 + 5 = 15；
> 第 2 种方案：staple[0] + drinks[1] = 10 + 5 = 15；
> 第 3 种方案：staple[0] + drinks[2] = 10 + 2 = 12；
> 第 4 种方案：staple[2] + drinks[0] = 5 + 5 = 10；
> 第 5 种方案：staple[2] + drinks[1] = 5 + 5 = 10；
> 第 6 种方案：staple[2] + drinks[2] = 5 + 2 = 7。

**示例 2：**

> 输入：staple = [2,1,1], drinks = [8,9,5,1], x = 9
>
> 输出：8
>
> 解释：小扣有 8 种购买方案，所选主食与所选饮料在数组中对应的下标分别是：
> 第 1 种方案：staple[0] + drinks[2] = 2 + 5 = 7；
> 第 2 种方案：staple[0] + drinks[3] = 2 + 1 = 3；
> 第 3 种方案：staple[1] + drinks[0] = 1 + 8 = 9；
> 第 4 种方案：staple[1] + drinks[2] = 1 + 5 = 6；
> 第 5 种方案：staple[1] + drinks[3] = 1 + 1 = 2；
> 第 6 种方案：staple[2] + drinks[0] = 1 + 8 = 9；
> 第 7 种方案：staple[2] + drinks[2] = 1 + 5 = 6；
> 第 8 种方案：staple[2] + drinks[3] = 1 + 1 = 2；

**提示：**

* 1 <= staple.length <= 10^5
* 1 <= drinks.length <= 10^5
* 1 <= staple[i],drinks[i] <= 10^5
* 1 <= x <= 2*10^5

### 题解

```java

class Solution {
    // 树状数组
    public int breakfastNumber(int[] staple, int[] drinks, int x) {
        FenwickTree fenwickTree = new FenwickTree(100001);
        for (int drink : drinks) {
            fenwickTree.update(drink, 1);
        }
        long ans = 0;
        int MOD = 1000000000 + 7;
        for (int s : staple) {
            if (s > x) {
                continue;
            }
            // 防止x-s超过树状数组范围
            if(x - s >= 100001){
                ans = (ans + drinks.length) % MOD;
            } else{
                ans = (ans + fenwickTree.query(x - s)) % MOD;
            }
            
        }
        return (int)(ans%MOD);
    }

    // 双指针
    public int breakfastNumber2(int[] staple, int[] drinks, int x) {
        long ans = 0;
        int MOD = 1000000000 + 7;
        // 双指针
        bucketSort(staple);
        bucketSort(drinks);
        int i = 0;
        int j = drinks.length - 1;
        while (i < staple.length && j >= 0) {
            if (staple[i] + drinks[j] > x) {
                j--;
            } else {
                ans = (int) (ans + j + 1) % MOD;
                i++;
            }
        }
        return (int) (ans % MOD);
    }

    //  桶排序+二分法
    public int breakfastNumber1(int[] staple, int[] drinks, int x) {
        bucketSort(staple);
        bucketSort(drinks);
        return staple.length > drinks.length ? upperBoundSum(drinks, staple, x) :
                upperBoundSum(staple, drinks, x);
    }


    public int upperBoundSum(int[] arr1, int[] arr2, int target) {
        long ans = 0;
        int MOD = 1000000000 + 7;
        for (int i = 0; i < arr1.length; i++) {
            if (arr1[i] > target || arr1[i] + arr2[0] > target) {
                break;
            }
            int j = upperBinarySearch(arr2, target - arr1[i]);
            ans += j;
        }
        return (int) (ans % MOD);
    }

    // 二分查找上边界
    public int upperBinarySearch(int[] arr, int target) {
        int left = 0;
        int right = arr.length;
        while (left < right) {
            int mid = left + (right - left) / 2;
            if (arr[mid] <= target) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        return left;
    }

    // 桶排序
    public void bucketSort(int[] nums) {
        int[] buckets = new int[100001];
        for (int num : nums) {
            buckets[num]++;
        }
        int i = 0;
        int j = 0;
        while (j < nums.length) {
            if (buckets[i] == 0) {
                i++;
            } else {
                nums[j++] = i;
                buckets[i]--;
            }
        }
    }

    public class FenwickTree {

        /**
         * 预处理数组
         */
        private int[] tree;
        private int len;

        public FenwickTree(int n) {
            this.len = n;
            tree = new int[n + 1];
        }

        /**
         * 单点更新
         *
         * @param i     原始数组索引 i
         * @param delta 变化值 = 更新以后的值 - 原始值
         */
        public void update(int i, int delta) {
            // 从下到上更新，注意，预处理数组，比原始数组的 len 大 1，故 预处理索引的最大值为 len
            while (i <= len) {
                tree[i] += delta;
                i += lowbit(i);
            }
        }

        /**
         * 查询前缀和
         *
         * @param i 前缀的最大索引，即查询区间 [0, i] 的所有元素之和
         */
        public int query(int i) {
            // 从右到左查询
            int sum = 0;
            while (i > 0) {
                sum += tree[i];
                i -= lowbit(i);
            }
            return sum;
        }

        public int lowbit(int x) {
            return x & (-x);
        }
    }
}

```

