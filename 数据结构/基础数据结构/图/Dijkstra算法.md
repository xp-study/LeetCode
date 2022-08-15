# 单源最短路径问题

#### 朴素Dijkstra算法

朴素Dijkstra算法核心思路是贪心算法,流程如下：

1. 首先，`Dijkstra` 算法需要从当前全部未确定最短路的点中，找到距离源点最短的点 x。
2. 其次，通过点 xx 更新其他所有点距离源点的最短距离。例如目前点 A 距离源点最短，距离为 3；有一条 A->B 的有向边，权值为 1，那么从源点先去 A 点再去 B 点距离为 3 + 1 = 4，若原先从源点到 B 的有向边权值为 5，那么我们便可以更新 B 到源点的最短距离为 4。
3. 当全部其他点都遍历完成后，一次循环结束，将 x*x* 标记为已经确定最短路。进入下一轮循环，直到全部点被标记为确定了最短路。

> 我们通过一个[例子]对 Dijkstra 算法的流程深入了解一下：

![img](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/29.jpg)以上图片为一个有向带权图，圆圈中为节点序号，箭头上为边权，右侧为所有点距离源点 `0` 的距离。

![image.png](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/30.jpg)

将顶点 `0` 进行标识，并作为点 x，更新其到其他所有点的距离。一轮循环结束。

![image.png](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/31.jpg)

![image.png](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/32.jpg)

将顶点 `2` 进行标识，并作为新的点 x*x*，更新。我们看到，原本点 `1` 的最短距离为 `5`，被更新为了 `3`。同理还更新了点 `3` 和点 `4` 的最短距离。

![image.png](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/33.jpg)

![image.png](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/34.jpg)

将顶点 `1` 进行标识，并作为新的点 x*x*，同样更新了点 `4` 到源点的最短距离。

![image.png](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/35.jpg)

再分别标识点 `4` 和点 `3`，循环结束。

我们来看在实现时需要的代码支持：

1. `首先，Dijkstra 算法需要存储各个边权，由于本题节点数量不超过 100100，所以代码中使用了邻接矩阵 g[i][j] 存储从点 i 到点 j 的距离。若两点之间没有给出有向边，则初始化为 inf。算法还需要记录所有点到源点的最短距离，代码中使用了 dist[i] 数组存储源点到点 i 的最短距离，初始值也全部设为 inf。由于本题源点为 K，所以该点距离设为 0。`
2. `其次，Dijkstra 算法需要标记某一节点是否已确定了最短路，在代码中使用了 used[i] 数组存储，若已确定最短距离，则值为 true，否则值为 false。`
3. `之所以 `inf` 设置为 `INT_MAX / 2`，是因为在更新最短距离的时候，要有两个距离相加，为了防止溢出 `int` 型，所以除以 `2`。`

```java
class Solution {
    public int networkDelayTime(int[][] times, int n, int k) {
        final int INF = Integer.MAX_VALUE / 2;

        // 邻接矩阵存储边信息
        int[][] g = new int[n][n];
        for (int i = 0; i < n; ++i) {
            Arrays.fill(g[i], INF);
        }
        for (int[] t : times) {
            // 边序号从 0 开始
            int x = t[0] - 1, y = t[1] - 1;
            g[x][y] = t[2];
        }

        // 从源点到某点的距离数组
        int[] dist = new int[n];
        Arrays.fill(dist, INF);
        // 由于从 k 开始，所以该点距离设为 0，也即源点
        dist[k - 1] = 0;

        // 节点是否被更新数组
        boolean[] used = new boolean[n];

        for (int i = 0; i < n; ++i) {
            // 在还未确定最短路的点中，寻找距离最小的点
            int x = -1;
            for (int y = 0; y < n; ++y) {
                if (!used[y] && (x == -1 || dist[y] < dist[x])) {
                    x = y;
                }
            }

            // 用该点更新所有其他点的距离
            used[x] = true;
            for (int y = 0; y < n; ++y) {
                dist[y] = Math.min(dist[y], dist[x] + g[x][y]);
            }
        }

        // 找到距离最远的点
        int ans = Arrays.stream(dist).max().getAsInt();
        return ans == INF ? -1 : ans;
    }
}
```



#### 堆优化Dijkstra算法

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/1.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/2.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/3.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/4.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/5.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/6.jpg)

第一层，遍历顶点A：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/7.jpg)

第二层，遍历A的邻接顶点B和C：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/8.jpg)

第三层，遍历顶点B的邻接顶点D、E，遍历顶点C的邻接顶点F：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/9.jpg)

第四层，遍历顶点E的邻接顶点G，也就是目标节点：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/10.jpg)

由此得出，图中顶点A到G的（第一条）最短路径是A-B-E-G：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/11.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/12.jpg)

换句话说，就是寻找从A到G之间，权值之和最小的路径。

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/13.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/14.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/15.jpg)

————————————

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/16.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/17.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/18.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/19.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/20.jpg)

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/21.jpg)

究竟什么是迪杰斯特拉算法？它是如何寻找图中顶点的最短路径呢？

这个算法的本质，是不断刷新起点与其他各个顶点之间的 “距离表”。

让我们来演示一下迪杰斯特拉的详细过程：

第1步，创建距离表。表中的Key是顶点名称，Value是**从起点A到对应顶点的已知最短距离**。但是，一开始我们并不知道A到其他顶点的最短距离是多少，Value默认是无限大：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/22.jpg)

第2步，遍历起点A，找到起点A的邻接顶点B和C。从A到B的距离是5，从A到C的距离是2。把这一信息刷新到距离表当中：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/23.jpg)

第3步，从距离表中找到从A出发距离最短的点，也就是顶点C。

第4步，遍历顶点C，找到顶点C的邻接顶点D和F（A已经遍历过，不需要考虑）。从C到D的距离是6，所以A到D的距离是2+6=8；从C到F的距离是8，所以从A到F的距离是2+8=10。把这一信息刷新到表中：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/24.jpg)

接下来重复第3步、第4步所做的操作：

第5步，也就是第3步的重复，从距离表中找到从A出发距离最短的点（C已经遍历过，不需要考虑），也就是顶点B。

第6步，也就是第4步的重复，遍历顶点B，找到顶点B的邻接顶点D和E（A已经遍历过，不需要考虑）。从B到D的距离是1，所以A到D的距离是5+1=6，**小于距离表中的8**；从B到E的距离是6，所以从A到E的距离是5+6=11。把这一信息刷新到表中：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/25.jpg)

（在第6步，A到D的距离从8刷新到6，可以看出距离表所发挥的作用。距离表通过迭代刷新，用新路径长度取代旧路径长度，最终可以得到从起点到其他顶点的最短距离）

第7步，从距离表中找到从A出发距离最短的点（B和C不用考虑），也就是顶点D。

第8步，遍历顶点D，找到顶点D的邻接顶点E和F。从D到E的距离是1，所以A到E的距离是6+1=7，**小于距离表中的11**；从D到F的距离是2，所以从A到F的距离是6+2=8，**小于距离表中的10**。把这一信息刷新到表中：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/26.jpg)

第9步，从距离表中找到从A出发距离最短的点，也就是顶点E。

第10步，遍历顶点E，找到顶点E的邻接顶点G。从E到G的距离是7，所以A到G的距离是7+7=14。把这一信息刷新到表中：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/27.jpg)

第11步，从距离表中找到从A出发距离最短的点，也就是顶点F。

第10步，遍历顶点F，找到顶点F的邻接顶点G。从F到G的距离是3，所以A到G的距离是8+3=11，**小于距离表中的14**。把这一信息刷新到表中：

![单源最短路径问题](http://gitlab.wsh-study.com/xp-study/LeeteCode/-/blob/master/数据结构/基础数据结构/图/images/Dijkstra算法/28.jpg)

就这样，除终点以外的全部顶点都已经遍历完毕，距离表中存储的是从起点A到所有顶点的最短距离。显然，从A到G的最短距离是11。（路径：A-C-D-F-G）

按照上面的思路，我们来看一下代码实现：

```java
    public int[] Dijkstra(int[][] times, int n, int k) {
        Map<Integer, List<int[]>> graph = new HashMap<>();
        for (int[] time : times) {
            graph.computeIfAbsent(time[0], t -> new ArrayList<>()).add(new int[]{time[1], time[2]});
        }

        int[] distances = new int[n + 1];
        Arrays.fill(distances, Integer.MAX_VALUE);

        boolean[] visited = new boolean[n + 1];

        // 起点的距离设置为0
        distances[k] = 0;

        // 优先队列 按照从小到大排列
        PriorityQueue<int[]> queue = new PriorityQueue<int[]>((a, b) -> a[1] - b[1]);
        // 将起点放入队列
        queue.offer(new int[]{k, 0});
        while (!queue.isEmpty()) {
            int[] poll = queue.poll();
            int cur = poll[0];
            if (visited[cur]) {
                continue;
            }
            visited[cur] = true;

            List<int[]> neighbors = graph.getOrDefault(cur, new ArrayList<int[]>());

            for (int[] neighbor : neighbors) {
                int to = neighbor[0];
                if (visited[to]) {
                    continue;
                }
                // 松弛操作
                distances[to] = Math.min(distances[to], distances[cur] + neighbor[1]);
                queue.add(new int[]{to, distances[to]});
            }
        }
        return distances;
    }
```

**复杂度分析**

朴素写法的复杂度如下：

* 时间复杂度：O*(*n*2+*m)，其中 m是数组times 的长度。
* 空间复杂度：O(n^2)。邻接矩阵需占用 O(n^2)的空间。

堆的写法复杂度如下：

* 时间复杂度：*O*(*m*log*m*)，其中 m 是数组times的长度。
* 空间复杂度：O(n+m)。
