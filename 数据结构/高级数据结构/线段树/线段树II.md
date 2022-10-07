# 线段树II(动态开点)

#### 为什么要使用线段树见(线段树I)

#### 为什么要使用动态开点线段树

很多时候，题目中都没有给出很具体的范围，只有数据的取值范围，一般都很大，所以我们更常用的是「动态开点」

#### 常见动态开点线段树模板如下:

**覆盖式更新 查询区间最大值**
```java
   // 节点实现 动态开点 区间更新 覆盖式更新 懒更新 求区间最大值
    class SegmentTree {

        int left;
        int right;
        SegmentTree leftChild;
        SegmentTree rightChild;
        int val;
        Integer lazy;

        public SegmentTree(int left, int right) {
            this.left = left;
            this.right = right;
        }


        public void pushDown(SegmentTree root) {

            int mid = root.left + (root.right - root.left) / 2;
            if (root.leftChild == null) {
                root.leftChild = new SegmentTree(root.left, mid);
            }

            if (root.rightChild == null) {
                root.rightChild = new SegmentTree(mid + 1, root.right);
            }

            if (root.lazy == null) {
                return;
            }

            root.leftChild.lazy = root.lazy;
            root.leftChild.val = root.lazy;

            root.rightChild.lazy = root.lazy;
            root.rightChild.val =  root.lazy;

            root.lazy = null;
        }

        public void pushUp(SegmentTree root) {
            root.val = Math.max(root.leftChild.val, root.rightChild.val);
        }

        public int query(SegmentTree root, int start, int end) {
            if (start <= root.left && end >= root.right) {
                return root.val;
            }

            if (start > root.right||end < root.left) {
                return 0;
            } 

            pushDown(root);
            return Math.max(query(root.leftChild, start, end), query(root.rightChild, start, end));
        }

        public void update(SegmentTree root, int start, int end, int val) {
            if (start <= root.left && end >= root.right) {
                root.val = val;
                root.lazy = val;
                return;
            }

            if (end < root.left||start > root.right) {
                return;
            }

            pushDown(root);
            update(root.leftChild, start, end, val);
            update(root.rightChild, start, end, val);
            pushUp(root);
        }
    }
```

**覆盖式更新 查询区间和**

```java
    // 节点实现 动态开点 区间更新 覆盖式更新 懒更新 求区间和
    class SegmentTree {

        int left;
        int right;
        SegmentTree leftChild;
        SegmentTree rightChild;
        int val;
        Integer lazy;

        public SegmentTree(int left, int right) {
            this.left = left;
            this.right = right;
        }


        public void pushDown(SegmentTree root) {

            int mid = root.left + (root.right - root.left) / 2;

            if (root.leftChild == null) {
                root.leftChild = new SegmentTree(root.left, mid);
            }

            if (root.rightChild == null) {
                root.rightChild = new SegmentTree(mid + 1, root.right);
            }

            if (root.lazy == null) {
                return;
            }

            root.leftChild.lazy = root.lazy;
            root.leftChild.val = (root.leftChild.right - root.leftChild.left + 1) * root.lazy;

            root.rightChild.lazy = root.lazy;
            root.rightChild.val = (root.rightChild.right - root.rightChild.left + 1) * root.lazy;
            root.lazy = null;
        }

        public void pushUp(SegmentTree root) {
            root.val = root.leftChild.val + root.rightChild.val;
        }

        public int query(SegmentTree root, int start, int end) {

           if (start <= root.left && end >= root.right) {
                return root.val;
            }

            if (start > root.right||end < root.left) {
                return 0;
            } 

            pushDown(root);
            int leftAns = query(root.leftChild, start, end);
            int rightAns = query(root.rightChild, start, end);
            return leftAns + rightAns;
        }

        public void update(SegmentTree root, int start, int end, int val) {
            if (start <= root.left && end >= root.right) {
                root.val = (root.right - root.left + 1) * val;
                root.lazy = val;
                return;
            }

            if (end < root.left||start > root.right) {
                return;
            } 

            pushDown(root);
            update(root.leftChild, start, end, val);
            update(root.rightChild, start, end, val);
            pushUp(root);
        }
    }
```

**增量式式更新(以区间加的方式更新) 查询区间最大值**

```java
    // 节点实现 动态开点 区间更新 增量式更新(以区间加的方式更新) 懒更新 求区间最大值
    class SegmentTree {

        int left;
        int right;
        SegmentTree leftChild;
        SegmentTree rightChild;
        int val;
        int lazy;

        public SegmentTree(int left, int right) {
            this.left = left;
            this.right = right;
        }


        public void pushDown(SegmentTree root) {

            int mid = root.left + (root.right - root.left) / 2;
            if (root.leftChild == null) {
                root.leftChild = new SegmentTree(root.left, mid);
            }

            if (root.rightChild == null) {
                root.rightChild = new SegmentTree(mid + 1, root.right);
            }

            if (root.lazy==0){
                return;
            }

            root.leftChild.lazy += root.lazy;
            root.leftChild.val += root.lazy;

            root.rightChild.lazy += root.lazy;
            root.rightChild.val += root.lazy;
            root.lazy = 0;
        }

        public void pushUp(SegmentTree root) {
            root.val = Math.max(root.leftChild.val, root.rightChild.val);
        }

        public int query(SegmentTree root, int start, int end) {
            if (start <= root.left && end >= root.right) {
                return root.val;
            }

            if (start > root.right||end < root.left) {
                return 0;
            }

            pushDown(root);
            return Math.max(query(root.leftChild, start, end), query(root.rightChild, start, end));
        }

        public void update(SegmentTree root, int start, int end, int val) {
            if (start <= root.left && end >= root.right) {
                root.val += val;
                root.lazy += val;
                return;
            }

            if (end < root.left || start > root.right) {
                return;
            } 

            pushDown(root);
            update(root.leftChild, start, end, val);
            update(root.rightChild, start, end, val);
            pushUp(root);
        }
    }
```

**增量式更新(以区间加的方式更新) 查询指定下标的值**

```java

  int mod = 26;
    // 节点实现 动态开点 区间更新 增量式更新 懒更新 求单个点的值
    class SegmentTree {
        int left;
        int right;
        SegmentTree leftChild;
        SegmentTree rightChild;
        long val;
        long addLazy;


        public SegmentTree(int left, int right) {
            this.left = left;
            this.right = right;
            this.addLazy = 0;
        }


        public void pushUp(SegmentTree root) {
            root.val = (root.leftChild.val + root.rightChild.val + mod) % mod;
        }

        public void pushDown(SegmentTree root) {
            int mid = root.left + (root.right - root.left) / 2;

            if (root.leftChild == null) {
                root.leftChild = new SegmentTree(root.left, mid);
            }

            if (root.rightChild == null) {
                root.rightChild = new SegmentTree(mid + 1, root.right);
            }

            if (root.addLazy == 0) {
                return;
            }

            root.leftChild.val = (root.leftChild.val + root.addLazy + mod) % mod;
            root.leftChild.addLazy = (root.leftChild.addLazy + root.addLazy + mod) % mod;

            root.rightChild.val = (root.rightChild.val + root.addLazy + mod) % mod;
            root.rightChild.addLazy = (root.rightChild.addLazy + root.addLazy + mod) % mod;

            root.addLazy = 0;
        }

        public void update(SegmentTree root, int start, int end, int val) {
            if (root.left > end || root.right < start) {
                return;
            }

            if (root.left >= start && root.right <= end) {
                root.val = (root.val + val + mod) % mod;
                root.addLazy = (root.addLazy + val + mod) % mod;
                return;
            }

            pushDown(root);
            update(root.leftChild, start, end, val);
            update(root.rightChild, start, end, val);
            pushUp(root);
        }

        public int query(SegmentTree root, int start, int end) {
            if (start > root.right || end < root.left) {
                return 0;
            }

            if (root.left >= start && root.right <=  end) {
                return (int) root.val;
            }

            pushDown(root);

            int leftAns = query(root.leftChild, start, end);
            int rightAns = query(root.rightChild, start, end);
            return (leftAns + rightAns + mod) % mod;
        }
    }

```

**增量式更新(以区间加或区间乘的方式更新) 查询指定下标的值**

```java
    // 节点实现 动态开点 区间更新 增量式更新(以区间加或区间乘的方式更新) 懒更新 查询指定下标的值
    int mod = (int)1e9;

    class SegmentTree {
        int left;
        int right;
        SegmentTree leftChild;
        SegmentTree rightChild;
        long val;
        long mulLazy;
        long addLazy;


        public SegmentTree(int left, int right) {
            this.left = left;
            this.right = right;
            this.mulLazy = 1;
            this.addLazy = 0;
        }


        public void pushUp(SegmentTree root) {
            root.val = root.leftChild.val + root.rightChild.val;
        }

        public void pushDown(SegmentTree root) {
            int mid = root.left + (root.right - root.left) / 2;

            if (root.leftChild == null) {
                root.leftChild = new SegmentTree(root.left, mid);
            }

            if (root.rightChild == null) {
                root.rightChild = new SegmentTree(mid + 1, root.right);
            }


            if (root.addLazy == 0 && root.mulLazy == 1) {
                return;
            }

            root.leftChild.val = (root.leftChild.val * root.mulLazy + root.addLazy) % mod;
            root.leftChild.mulLazy = (root.leftChild.mulLazy * root.mulLazy) % mod;
            root.leftChild.addLazy = (root.leftChild.addLazy * root.mulLazy + root.addLazy) % mod;

            root.rightChild.val = (root.rightChild.val * root.mulLazy + root.addLazy) % mod;
            root.rightChild.mulLazy = (root.rightChild.mulLazy * root.mulLazy) % mod;
            root.rightChild.addLazy = (root.rightChild.addLazy * root.mulLazy + root.addLazy) % mod;

            root.addLazy = 0;
            root.mulLazy = 1;
        }

        public void update(SegmentTree root, int start, int end, int val) {
            if (root.left >= start && root.right <= end) {
                if (val > 0) {
                    root.val = (root.val + val) % mod;
                    root.addLazy = (root.addLazy + val) % mod;
                } else {
                    root.val = (root.val * -val) % mod;
                    root.mulLazy = (root.mulLazy * -val) % mod;
                    root.addLazy = (root.addLazy * -val) % mod;
                }
                return;
            }
          
            if (root.left > end || root.right < start) {
                return;
            }

            pushDown(root);
            update(root.leftChild, start, end, val);
            update(root.rightChild, start, end, val);
            pushUp(root);
        }

        public int query(SegmentTree root, int start, int end) {
           if (root.left == start && root.right == end) {
                return (int) root.val;
            }

           if ( start > root.right || end < root.left) {
                return 0;
            }

            pushDown(root);

            int leftAns = query(root.leftChild, start, end);
            int rightAns = query(root.rightChild, start, end);
            return leftAns + rightAns;
        }
    }

```

**增量式更新(以区间加的方式更新) 查询查询区间和**

```java

    // 节点实现 动态开点 区间更新 增量式更新(以区间加的方式更新) 懒更新 求区间和
    class SegmentTree {

        int left;
        int right;
        SegmentTree leftChild;
        SegmentTree rightChild;
        long val;
        long lazy;

        public SegmentTree(int left, int right) {
            this.left = left;
            this.right = right;
        }


        public void pushDown(SegmentTree root) {

            int mid = root.left + (root.right - root.left) / 2;

            if (root.leftChild == null) {
                root.leftChild = new SegmentTree(root.left, mid);
            }

            if (root.rightChild == null) {
                root.rightChild = new SegmentTree(mid + 1, root.right);
            }

            if (root.lazy == 0) {
                return;
            }

            root.leftChild.lazy = (root.leftChild.lazy + root.lazy) % mod;
            root.leftChild.val = (root.leftChild.val + (root.leftChild.right - root.leftChild.left + 1) * root.lazy) % mod;

            root.rightChild.lazy = (root.rightChild.lazy + root.lazy) % mod;
            root.rightChild.val = (root.rightChild.val + (root.rightChild.right - root.rightChild.left + 1) * root.lazy) % mod;
            root.lazy = 0;
        }

        public void pushUp(SegmentTree root) {
            root.val = (root.leftChild.val + root.rightChild.val) % mod;
        }

        public int query(SegmentTree root, int start, int end) {
            if (start <= root.left && end >= root.right) {
                return (int) root.val;
            }


            if (end < root.left || start > root.right) {
                return 0;
            }

            pushDown(root);
            return (query(root.leftChild, start, end) + query(root.rightChild, start, end)) % mod;
        }

        public void update(SegmentTree root, int start, int end, long val) {

            if (start <= root.left && end >= root.right) {
                root.val = (root.val + (root.right - root.left + 1) * val) % mod;
                root.lazy = (root.lazy + val) % mod;
                return;
            }

            if (end < root.left || start > root.right) {
                return;
            }

            pushDown(root);
            update(root.leftChild, start, end, val);
            update(root.rightChild, start, end, val);
            pushUp(root);
        }
    }

```

// 节点实现 动态开点 单点更新 增量式更新 懒更新 求区间和(解决逆序对问题)

```java

 class SegmentTree {
        long left;
        long right;
        SegmentTree leftChild;
        SegmentTree rightChild;
        int val;

        public SegmentTree(long left, long right) {
            this.left = left;
            this.right = right;
        }

        public void buildDown(SegmentTree root) {

            long mid = root.left + (root.right - root.left) / 2;

            if (root.leftChild == null) {
                root.leftChild = new SegmentTree(root.left, mid);
            }

            if (root.rightChild == null) {
                root.rightChild = new SegmentTree(mid + 1, root.right);
            }
        }

        public int query(SegmentTree root, long start, long end) {
            if (start == root.left && end == root.right) {
                return root.val;
            }

            buildDown(root);
            long mid = root.left + (root.right - root.left) / 2;
            if (end <= mid) {
                return query(root.leftChild, start, end);
            } else if (start >= mid + 1) {
                return query(root.rightChild, start, end);
            } else {
                return query(root.leftChild, start, mid) + query(root.rightChild, mid + 1, end);
            }
        }

        public void update(SegmentTree root, long index, int val) {
            if (index == root.left && index == root.right) {
                root.val += val;
                root.leftChild = null;
                root.rightChild = null;
                return;
            }

            buildDown(root);
            long mid = root.left + (root.right - root.left) / 2;
            if (index <= mid) {
                update(root.leftChild, index, val);
            } else if (index >= mid + 1) {
                update(root.rightChild, index, val);
            }
            root.val = root.leftChild.val + root.rightChild.val;
        }
    }

```