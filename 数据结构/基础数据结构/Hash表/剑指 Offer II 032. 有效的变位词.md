#### 剑指 Offer II 032. 有效的变位词

给定两个字符串 `s` 和 `t` ，编写一个函数来判断它们是不是一组变位词（字母异位词）。

**注意：**若 `*s*` 和 `*t*` 中每个字符出现的次数都相同且**字符顺序不完全相同**，则称 `*s*` 和 `*t*` 互为变位词（字母异位词）。

**示例 1:**

```shell
输入: s = "anagram", t = "nagaram"
输出: true
```

**示例 2:**

```shell
输入: s = "rat", t = "car"
输出: false
```

**示例 3:**

```shell
输入: s = "a", t = "a"
输出: false
```

**提示:**

- `1 <= s.length, t.length <= 5 * 104`
- `s` and `t` 仅包含小写字母

**进阶  **如果输入字符串包含 unicode 字符怎么办？你能否调整你的解法来应对这种情况？

### 题解

对于进阶问题，Unicode 是为了解决传统字符编码的局限性而产生的方案，它为每个语言中的字符规定了一个唯一的二进制编码。而 Unicode 中可能存在一个字符对应多个字节的问题，为了让计算机知道多少字节表示一个字符，面向传输的编码方式的UTF−8 和UTF−16 也随之诞生逐渐广泛使用，具体相关的知识读者可以继续查阅相关资料拓展视野，这里不再展开。

回到本题，进阶问题的核心点在于「字符是离散未知的」，因此我们用哈希表维护对应字符的频次即可。同时读者需要注意 Unicode 一个字符可能对应多个字节的问题，不同语言对于字符串读取处理的方式是不同的。

```java
class Solution {
    public boolean isAnagram(String s, String t) {
        if (s.equals(t)) {
            return false;
        }   

        if (s.length() != t.length()) {
            return false;
        }
        
        Map<Character, Integer> table = new HashMap<>();
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            table.put(ch, table.getOrDefault(ch, 0) + 1);
        }

        for (int i = 0; i < t.length(); i++) {
            char ch = t.charAt(i);
            table.put(ch, table.getOrDefault(ch, 0) - 1);
            if (table.get(ch) < 0) {
                return false;
            }
        }
        return true;
    }
}
```

