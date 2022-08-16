#### 剑指 Offer II 112. 最长递增路径

给定一个 `m x n` 整数矩阵 `matrix` ，找出其中 **最长递增路径** 的长度。

对于每个单元格，你可以往上，下，左，右四个方向移动。 **不能** 在 **对角线** 方向上移动或移动到 **边界外**（即不允许环绕）。

**示例 1：**

![img](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/深度与广度优先搜索/images/最长递增路径/1.jpg)

```shell
输入：matrix = [[9,9,4],[6,6,8],[2,1,1]]
输出：4 
解释：最长递增路径为 [1, 2, 6, 9]。
```

**示例 2：**

![img](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/深度与广度优先搜索/images/最长递增路径/2.jpg)

```shell
输入：matrix = [[3,4,5],[3,2,6],[2,2,1]]
输出：4 
解释：最长递增路径是 [3, 4, 5, 6]。注意不允许在对角线方向上移动。
```

**示例 3：**

```shell
输入：matrix = [[1]]
输出：1
```

**提示：**

* m == matrix.length
* n == matrix[i].length
* 1 <= m, n <= 200
* 0 <= matrix[i][j] <= 231 - 1

### 题解

**深度优先搜索**

```java
class Solution {
    int[][] memory;

    public int longestIncreasingPath(int[][] matrix) {
        int rows = matrix.length;
        int cols = matrix[0].length;

        memory = new int[rows][cols];
        int ans = 0;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                ans = Math.max(ans, dfs(matrix, rows, cols, i, j, -1));
            }
        }

        return ans;
    }


    public int dfs(int[][] matrix, int rows, int cols, int x, int y, int pre) {
        if (x < 0 || x >= rows || y < 0 || y >= cols) {
            return 0;
        }
        int cur = matrix[x][y];
        if (cur <= pre) {
            return 0;
        }

        if (memory[x][y] > 0) {
            return memory[x][y];
        }

        int up = dfs(matrix, rows, cols, x, y - 1, cur);
        int down = dfs(matrix, rows, cols, x, y + 1, cur);
        int left = dfs(matrix, rows, cols, x - 1, y, cur);
        int right = dfs(matrix, rows, cols, x + 1, y, cur);

        int max = Math.max(Math.max(up, down), Math.max(left, right));
        memory[x][y] = max + 1;
        return max + 1;
    }
}
```

