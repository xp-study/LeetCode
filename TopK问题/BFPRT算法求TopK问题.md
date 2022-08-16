# BFPRT算法的主要步骤和代码实现

## 解决的问题

求一个无序数组中第k小的数。约定：k是从1开始计数的，即最小的那个数是第一小的数。

## 解决方案

1、快速排序：平均时间复杂度O(nlogn)，最坏时间复杂度O(n2)
2、堆：时间复杂度O(nlogk)
3、快速选择：平均时间复杂度O(n)，最坏时间复杂度O(n2)

例如：`1, 2, 3, 4, 5`，如果要求最5小的数，使用快速选择时间复杂度为O(n2)，原因是基准值选得不好，使得每次根据基准值划分的时候，其它的所有数字都被分到了一边。

第一轮以`1`作为基准值，小于基准值的放在左边，大于基准值的放在右边，得到的结果是`1, 2, 3, 4, 5`，发现目标数在基准值`1`的右边；第二轮以`2`作为基准值，得到的结果依旧是`1, 2, 3, 4, 5`；直到找到目标值。

优化：每次不以`[left, right]`范围内left位置的元素作为基准值，而是从left到right范围内随机选择一个作为基准值，通过随机化的方式来优化时间复杂度，在概率统计上，此时的时间复杂度为O(n)。

4、BFPRT算法
时间复杂度为严格的O(N)，而不是概率统计上的O(n)。BFPRT算法与快速选择最主要的区别在于选取基准值的方式不同，选取基准值之后后续的步骤都是一样的。所以理解BFPRT算法前提是要理解快速选择的过程。

## BFPRT算法的步骤

1. 以五个元素作为一组，对原数组进行分组，最后一个分组如果不足5个元素，依旧可以分为一个组；
2. 各个组进行组内排序；
3. 取出各个组的中位数，组成一个新的数组，暂且叫做【中位数数组】，最后一个组的元素个数若是偶数，去该组的上中位数或者下中位数都可以；
4. 递归调用BFPRT算法来求中位数数组的中位数；
5. 以上一步求得的中位数作为基准值pivot，对原数组进行partiton过程（快速选择）
6. 根据基准值和目标数的位置关系，如果未命中目标数，回到第一步重新执行。

对第四步的解释：

- 为什么不能直接求出来中位数数组的中位数？因为这个中位数数组里面的元素是无序的，不要被名字所迷惑；
- 为什么可以递归调用BFPRT算法来求中位数？首先这个中位数数组的数据规模肯定是比原数组小的，其次求解问题的语义是相同的，外层的BFPRT算法是求原数组的第k小的元素，调用过程是这样的int bfprt(int[] arr, int k)，如果要求中位数数组middleArr的中位数，就转化为求这个数组的第middleArr.length/2小的元素，所以说语义是一样的，内层的BFPRT算法调用过程就是int bfprt(int[] middleArr, int middleArr.length/2)。

## BFPRT算法的时间复杂度分析

假设BFPRT算法的数据规模是T(n)；

* 第一步分组的时间复杂度：O(1)；
* 第二步组内排序的时间复杂度：O(n)；
* 第三步组成中位数数组的时间复杂度：O(n)；
* 第四步递归调用BFPRT算法求中位数数组的中位数的时间复杂度：T(n/5)；
* 第五步partition的时间复杂度：O(n)；
* 第六步在未命中目标数的情况下，考虑最坏的情况：即左侧最多有多少个元素。反过来考虑，右侧最少有多少个元素。

![image-20210627180857515](http://gitlab.wsh-study.com/xp-study/LeeteCode/blob/master/TopK问题/images/BFPRT算法/1.jpg)

代码实现如下所示：

```java
package com.zuoshen;
/** 
 * BFPRT算法求topk，时间复杂度bO(n)
 *
 * @author wanglongfei    
 * E-mail: islongfei@gmail.com
 * @version 2017年8月5日
 * 
 */
public class BFPRT {
	
	    // 得到前k个最小的数
		public static int[] getMinKNumsByBFPRT(int[] arr, int k) {
			if (k < 1 || k > arr.length) {
				return arr;
			}
			int minKth = getMinKthByBFPRT(arr, k);
			int[] res = new int[k];//res前k个结果集
			int index = 0;
			
			for (int i = 0; i != arr.length; i++) {
				if (arr[i] < minKth) {
					res[index++] = arr[i];
				}
			}
			for (; index != res.length; index++) {
				res[index] = minKth;
			}
			return res;
		}
		
		
	   // 找出比k小的前k个数
		public static int getMinKthByBFPRT(int[] arr, int K) {
			int[] copyArr = copyArray(arr);
			return select(copyArr, 0, copyArr.length - 1, K - 1);
		}
		
       // 复制数组
		public static int[] copyArray(int[] arr) {
			int[] res = new int[arr.length];
			for (int i = 0; i != res.length; i++) {
				res[i] = arr[i];
			}
			return res;
		}
		
		
	      // 用划分值与k相比，依次递归排序
		public static int select(int[] arr, int begin, int end, int i) {
			if (begin == end) { //begin数组的开始 end数组的结尾  i表示要求的第k个数
				return arr[begin];
			}
			int pivot = medianOfMedians(arr, begin, end);//找出划分值（中位数组中的中位数）
			int[] pivotRange = partition(arr, begin, end, pivot);
			if (i >= pivotRange[0] && i <= pivotRange[1]) {//小于放左边，=放中间，大于放右边
				return arr[i];
			} else if (i < pivotRange[0]) {
				return select(arr, begin, pivotRange[0] - 1, i);
			} else {
				return select(arr, pivotRange[1] + 1, end, i);
			}
		}
		
		
	     //找出中位数组中的中位数  
		public static int medianOfMedians(int[] arr, int begin, int end) {
			int num = end - begin + 1;              
			int offset = num % 5 == 0 ? 0 : 1;       //分组:每组5个数，不满5个单独占一组
			int[] mArr = new int[num / 5 + offset];  //mArr：中位数组成的数组
			for (int i = 0; i < mArr.length; i++) {  //计算分开后各数组的开始位置beginI 结束位置endI
				int beginI = begin + i * 5;
				int endI = beginI + 4;
				mArr[i] = getMedian(arr, beginI, Math.min(end, endI));//对于最后一组（不满5个数），结束位置要选择end
			}
			return select(mArr, 0, mArr.length - 1, mArr.length / 2);
		}
		
	    //划分过程，类似于快排
		public static int[] partition(int[] arr, int begin, int end, int pivotValue) {
			int small = begin - 1;
			int cur = begin;
			int big = end + 1;
			while (cur != big) {
				if (arr[cur] < pivotValue) {
					swap(arr, ++small, cur++);
				} else if (arr[cur] > pivotValue) {
					swap(arr, cur, --big);
				} else {
					cur++;
				}
			}
			int[] range = new int[2];
			range[0] = small + 1;//比划分值小的范围
			range[1] = big - 1;  //比划分值大的范围
			
			return range;
		}
		
		
	    //计算中位数
		public static int getMedian(int[] arr, int begin, int end) {
			insertionSort(arr, begin, end);//将数组中的5个数排序
			int sum = end + begin;
			int mid = (sum / 2) + (sum % 2);
			return arr[mid];
		}
		
		
	    // 数组中5个数排序（插入排序）
		public static void insertionSort(int[] arr, int begin, int end) {
			for (int i = begin + 1; i != end + 1; i++) {
				for (int j = i; j != begin; j--) {
					if (arr[j - 1] > arr[j]) {
						swap(arr, j - 1, j);
					} else {
						break;
					}
				}
			}
		}
		
		
	    // 交换元素顺序
		public static void swap(int[] arr, int index1, int index2) {
			int tmp = arr[index1];
			arr[index1] = arr[index2];
			arr[index2] = tmp;
		}
		
		
        //打印结果
		public static void printArray(int[] arr) {
			for (int i = 0; i != arr.length; i++) {
				System.out.print(arr[i] + " ");
			}
			System.out.println();
		}

		public static void main(String[] args) {
			int[] arr = { 6, 9, 1, 3, 1, 2, 2, 5, 6, 1, 3, 5, 9, 7, 2, 5, 6, 1, 9 };
			printArray(getMinKNumsByBFPRT(arr, 10));

		}

}
```

