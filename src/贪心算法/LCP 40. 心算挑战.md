#### LCP 40. 心算挑战

「力扣挑战赛」心算项目的挑战比赛中，要求选手从 N 张卡牌中选出 cnt 张卡牌，若这 cnt 张卡牌数字总和为偶数，则选手成绩「有效」且得分为 cnt 张卡牌数字总和。
给定数组 cards 和 cnt，其中 cards[i] 表示第 i 张卡牌上的数字。 请帮参赛选手计算最大的有效得分。若不存在获取有效得分的卡牌方案，则返回 0。

**示例 1：**

> 输入：cards = [1,2,8,9], cnt = 3
>
> 输出：18
>
> 解释：选择数字为 1、8、9 的这三张卡牌，此时可获得最大的有效得分 1+8+9=18。
>

**示例 2：**

> 输入：`cards = [3,3,1], cnt = 1`
>
> 输出：`0`
>
> 解释：不存在获取有效得分的卡牌方案。

**提示：**

- `1 <= cnt <= cards.length <= 10^5`
- `1 <= cards[i] <= 1000`

### 题解

## 方法：贪心

**思路及算法**

由于要求是偶数，那么可以两个两个找。两个奇数的和 与 两个偶数的和 一定是偶数，不会出现一奇一偶而且和为偶数的情况。
1.若cnt为奇数，那么结果中一定包含最大的偶数。此时将cnt减一就会变成下面的情况
2.若cnt为偶数，那么比较每两个偶数和每两个奇数的最大值，加入结果中

```java
class Solution {
     public int maxmiumScore(int[] cards, int cnt) {
        List<Integer> odds = new ArrayList<>();
        List<Integer> evens = new ArrayList<>();
        int n = cards.length;
        for (int i = 0; i < n; i++) {
            if ((cards[i] & 1) == 0) {
                evens.add(cards[i]);
            } else {
                odds.add(cards[i]);
            }
        }

        Collections.sort(odds);
        Collections.sort(evens);

        int ans = 0;
        if ((cnt & 1) != 0) {
            if (evens.size() == 0) {
                return 0;
            }
            ans += evens.get(evens.size() - 1);
            evens.remove(evens.size() - 1);
            cnt -= 1;
        }

        while (cnt > 0) {
            if (evens.size() > 2 && odds.size() >= 2) {

                int evenAns = evens.get(evens.size() - 1) + evens.get(evens.size() - 2);
                int oddAns = odds.get(odds.size() - 1) + odds.get(odds.size() - 2);
                if (evenAns > oddAns) {
                    ans += evenAns;
                    evens.remove(evens.size() - 1);
                    evens.remove(evens.size() - 1);
                } else {
                    ans += oddAns;
                    odds.remove(odds.size() - 1);
                    odds.remove(odds.size() - 1);
                }

            } else if (evens.size() >= 2) {
                int evenAns = evens.get(evens.size() - 1) + evens.get(evens.size() - 2);
                ans += evenAns;
                evens.remove(evens.size() - 1);
                evens.remove(evens.size() - 1);
            } else if (odds.size() >= 2) {
                int oddAns = odds.get(odds.size() - 1) + odds.get(odds.size() - 2);
                ans += oddAns;
                odds.remove(odds.size() - 1);
                odds.remove(odds.size() - 1);
            } else {
                return 0;
            }
            cnt -= 2;
        }
        return ans;
    }
}
```

