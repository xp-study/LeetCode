#### 剑指 Offer II 033. 变位词组

给定一个字符串数组 `strs` ，将 **变位词** 组合在一起。 可以按任意顺序返回结果列表。

**注意：**若两个字符串中每个字符出现的次数都相同且**字符顺序不完全相同**，则称它们互为变位词。

**示例 1:**

```shell
输入: strs = ["eat", "tea", "tan", "ate", "nat", "bat"]
输出: [["bat"],["nat","tan"],["ate","eat","tea"]]
```

**示例 2:**

```shell
输入: strs = [""]
输出: [[""]]
```

**示例 3:**

```shell
输入: strs = ["a"]
输出: [["a"]]
```

**提示：**

- `1 <= strs.length <= 104`
- `0 <= strs[i].length <= 100`
- `strs[i]` 仅包含小写字母

### 题解

#### 方法一：排序

由于互为字母异位词的两个字符串包含的字母相同，因此对两个字符串分别进行排序之后得到的字符串一定是相同的，故可以将排序之后的字符串作为哈希表的键。

```java
class Solution {
    public List<List<String>> groupAnagrams(String[] strs) {
        Map<String, List<String>> map = new HashMap<String, List<String>>();
        for (String str : strs) {
            char[] array = str.toCharArray();
            Arrays.sort(array);
            String key = new String(array);
            List<String> list = map.getOrDefault(key, new ArrayList<String>());
            list.add(str);
            map.put(key, list);
        }
        return new ArrayList<List<String>>(map.values());
    }
}
```

**复杂度分析**

![image-20210808121011176](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/数据结构/基础数据结构/Hash表/images/变位词组/1.jpg)

#### 方法二：计数

由于互为字母异位词的两个字符串包含的字母相同，因此两个字符串中的相同字母出现的次数一定是相同的，故可以将每个字母出现的次数使用字符串表示，作为哈希表的键。

由于字符串只包含小写字母，因此对于每个字符串，可以使用长度为 26 的数组记录每个字母出现的次数。需要注意的是，在使用数组作为哈希表的键时，不同语言的支持程度不同，因此不同语言的实现方式也不同。

```java
class Solution {
    public List<List<String>> groupAnagrams(String[] strs) {
        Map<String, List<String>> group = new HashMap<>();

        for (String str : strs) {
            int[] counts = new int[26];
            for (int i = 0; i < str.length(); i++) {
                counts[str.charAt(i) - 'a']++;
            }

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 26; i++) {
                if (counts[i] != 0) {
                    sb.append(i + 'a');
                    sb.append(counts[i]);
                }
            }

            String key = sb.toString();
            List<String> list = group.getOrDefault(key, new ArrayList<>());
            list.add(str);
            group.put(key, list);
        }
        return new ArrayList<>(group.values());
    }
}
```

**复杂度分析**

![image-20210808121109301](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/数据结构/基础数据结构/Hash表/images/变位词组/2.jpg)
