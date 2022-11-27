#### 剑指 Offer II 075. 数组相对排序

给定两个数组，`arr1` 和 `arr2`，

- `arr2` 中的元素各不相同
- `arr2` 中的每个元素都出现在 `arr1` 中

对 `arr1` 中的元素进行排序，使 `arr1` 中项的相对顺序和 `arr2` 中的相对顺序相同。未在 `arr2` 中出现过的元素需要按照升序放在 `arr1` 的末尾。

**示例：**

```shell
输入：arr1 = [2,3,1,3,2,4,6,7,9,2,19], arr2 = [2,1,4,3,9,6]
输出：[2,2,2,1,4,3,3,9,6,7,19]
```

**提示：**

* 1 <= arr1.length, arr2.length <= 1000
* 0 <= arr1[i], arr2[i] <= 1000
* arr2 中的元素 arr2[i] 各不相同
* arr2 中的每个元素 arr2[i] 都出现在 arr1 中

### 题解

**计数排序**

```java
class Solution {
    public int[] relativeSortArray(int[] arr1, int[] arr2) {
        int[] count = new int[1001];

        // 将 arr1 中的数记录下来
        for (int num1 : arr1) {
            count[num1]++;
        }

        // 先安排 arr2 中的数
        int index = 0;
        for (int num2 : arr2) {
            while (count[num2] > 0) {
                arr1[index++] = num2;
                count[num2]--;
            }
        }

        // 再排剩下的数
        for (int num = 0; num < count.length; num++) {
            while (count[num] > 0) {
                arr1[index++] = num;
                count[num]--;
            }
        }

        return arr1;
    }
}
```

