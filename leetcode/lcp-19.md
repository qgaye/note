# LCP 19 秋叶收藏集

```java
class Solution {
    public int minimumOperations(String leaves) {
        int[][] dp = new int[leaves.length()][3];
        // dp[i][0]表示状态为r，dp[i][1]表示状态为ry，dp[i][2]表示状态为ryr
        dp[0][0] = leaves.charAt(0) == 'r' ? 0 : 1;
        // 当只有一个字符时不存在ry和ryr状态，当只有两个字符时不存在ryr状态
        dp[0][1] = dp[0][2] = dp[1][2] = Integer.MAX_VALUE;
        for (int i = 1; i < dp.length; i++) {
            dp[i][0] = dp[i - 1][0] + (leaves.charAt(i) == 'r' ? 0 : 1);
            dp[i][1] = Math.min(dp[i - 1][0], dp[i - 1][1]) + (leaves.charAt(i) == 'y' ? 0 : 1);
            if (i >= 2) dp[i][2] = Math.min(dp[i - 1][1], dp[i - 1][2]) + (leaves.charAt(i) == 'r' ? 0 : 1);
        }
        return dp[dp.length - 1][2];
    }
}
```
