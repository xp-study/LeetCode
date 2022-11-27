#### 剑指 Offer II 035. 最小时间差

给定一个 24 小时制（小时:分钟 **"HH:MM"**）的时间列表，找出列表中任意两个时间的最小时间差并以分钟数表示。

**示例 1：**

```shell
输入：timePoints = ["23:59","00:00"]
输出：1
```

**示例 2：**

```shell
输入：timePoints = ["00:00","23:59","00:00"]
输出：0
```

**提示：**

- `2 <= timePoints <= 2 * 104`
- `timePoints[i]` 格式为 **"HH:MM"**

### 题解

```java
class Solution {
    public int findMinDifference(List<String> timePoints) {
        // 一天有 1440 分钟，如果 timePoints >= 1440 则表示有相等的时间，时间差为 0
        if (timePoints.size() >= 1440) {
            return 0;
        }

        // 用来存储每个时间的分钟
        int[] minutes = new int[timePoints.size()];
        for (int i = 0; i < timePoints.size(); i++) {
            // 计算分钟
            minutes[i] = minute(timePoints.get(i));
        }
        // 排序
        Arrays.sort(minutes);

        int min = Integer.MAX_VALUE;

        for (int i = 1; i < minutes.length; i++) {
            // 求出分钟差
            min = Math.min(min, minutes[i] - minutes[i - 1]);
            // 如果有最小分钟差，则直接返回
            if (min == 0) {
                return 0;
            }
        }
        // 最大时间和最小时间的分钟差可能最小，需要判断一下
        return Math.min(min, 1440 + minutes[0] - minutes[minutes.length - 1]);
    }

    public int minute(String s) {
        return s.charAt(0) * 600 + s.charAt(1) * 60 + s.charAt(3) * 10 + s.charAt(4);
    }
}
```

