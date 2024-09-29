<template>
  <el-container>
    <el-header>仪表盘</el-header>
    <el-main>
      <!-- 在每个 <el-row> 元素上添加 margin-bottom -->
      <el-row :gutter="20" class="dashboard-row">
        <!-- 应用数量展示 -->
        <el-col :span="8">
          <el-card class="dashboard-card">
            <h3>应用数量</h3>
            <div ref="applicationsChart" style="width: 100%; height: 200px;"></div>
            <p>当前总数: {{ totalApplications }}</p>
          </el-card>
        </el-col>

        <!-- 菜单数量展示 -->
        <el-col :span="8">
          <el-card class="dashboard-card">
            <h3>菜单数量</h3>
            <div ref="menusChart" style="width: 100%; height: 200px;"></div>
            <p>当前总数: {{ totalMenus }}</p>
          </el-card>
        </el-col>

        <!-- 用户数量展示 -->
        <el-col :span="8">
          <el-card class="dashboard-card">
            <h3>用户数量</h3>
            <div ref="usersChart" style="width: 100%; height: 200px;"></div>
            <p>当前总数: {{ totalUsers }}</p>
          </el-card>
        </el-col>
      </el-row>

      <el-row :gutter="20" class="dashboard-row">
        <!-- 最近新增应用 -->
        <el-col :span="24">
          <el-card class="dashboard-card">
            <h3>最近新增的应用</h3>
            <el-table :data="recentApplications" style="width: 100%">
              <el-table-column prop="title" label="标题" width="200" />
              <el-table-column label="图标" width="100" align="center" show-overflow-tooltip>
                <template #default="scope">
                  <template v-if="isUrl(scope.row.icon)">
                    <img :src="scope.row.icon" alt="自定义图标" width="25" height="25" />
                  </template>
                  <template v-else>
                    <icon :icon="scope.row.icon" :color="scope.row.icon_color || '#000'" width="25" height="25" />
                  </template>
                </template>
              </el-table-column>
              <el-table-column prop="link" label="链接" width="220" />
              <el-table-column prop="menu_id" label="菜单" width="150" align="center" show-overflow-tooltip>
                <template #default="scope">
                  <div v-if="scope && scope.row" style="display: flex; align-items: center; padding-left: 20px;">
                    <template v-if="isUrl(getMenuIcon(scope.row.menu_id))">
                      <img :src="getMenuIcon(scope.row.menu_id)" :style="{ color: getMenuIconColor(scope.row.menu_id) || '#000' }" width="25" height="25" style="margin-right: 8px;" />
                    </template>
                    <template v-else>
                      <icon :icon="getMenuIcon(scope.row.menu_id)" :color="getMenuIconColor(scope.row.menu_id) || '#000'" width="25" height="25" style="margin-right: 8px;" />
                    </template>
                    <span>{{ getMenuTitle(scope.row.menu_id) }}</span>
                  </div>
                </template>
              </el-table-column>
              <el-table-column label="状态" width="100">
                <template #default="scope">
                  <el-tag :type="scope.row.status === 'active' ? 'success' : 'danger'">
                    {{ scope.row.status === 'active' ? '启用' : '停用' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="created_at" label="创建时间" width="200">
                <template #default="scope">
                  <span>{{ new Date(scope.row.created_at).toLocaleString() }}</span>
                </template>
              </el-table-column>
            </el-table>
          </el-card>
        </el-col>
      </el-row>
    </el-main>
  </el-container>
</template>

<script>
import axios from 'axios';
import * as echarts from 'echarts';
import { Icon } from '@iconify/vue';

export default {
  components: {
    Icon,
  },
  data() {
    return {
      totalUsers: 0,
      totalApplications: 0,
      totalMenus: 0,
      recentApplications: [],
      menus: [], // 初始化菜单数据
      applicationsPercentage: 0,
      menusPercentage: 0,
      usersPercentage: 0,
      charts: {} // 存储图表实例
    };
  },
  mounted() {
    this.initCharts();
    this.fetchDashboardData();
  },
  beforeUnmount() {
    // 在组件销毁前，销毁所有图表实例
    for (let key in this.charts) {
      if (this.charts[key]) {
        this.charts[key].dispose();
      }
    }
  },
  methods: {
    // 初始化图表
    initCharts() {
      this.initChart(this.$refs.applicationsChart, this.applicationsPercentage, '应用数量', 'applicationsChart');
      this.initChart(this.$refs.menusChart, this.menusPercentage, '菜单数量', 'menusChart');
      this.initChart(this.$refs.usersChart, this.usersPercentage, '用户数量', 'usersChart');
    },
    // 初始化单个图表
    initChart(el, percentage, name, chartKey) {
      // 检查并销毁已有的 ECharts 实例
      if (this.charts[chartKey]) {
        this.charts[chartKey].dispose();
      }

      // 初始化新的图表实例
      const chart = echarts.init(el);
      const option = {
        title: {
          text: `${name}`,
          left: 'center',
          top: 'center',
          textStyle: {
            color: '#333',
            fontSize: 18,
            fontWeight: 'bold',
          }
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)',
        },
        series: [
          {
            name,
            type: 'pie',
            radius: ['60%', '80%'],
            avoidLabelOverlap: false,
            label: {
              show: false,
            },
            labelLine: {
              show: false,
            },
            data: [
              { value: percentage, name: name, itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 1, 1, [{ offset: 0, color: '#83bff6' }, { offset: 1, color: '#188df0' }]) }},
              { value: 100 - percentage, name: '剩余', itemStyle: { color: '#f2f2f2' } }
            ],
            animationType: 'scale',
            animationEasing: 'elasticOut',
            animationDelay: () => Math.random() * 200,
          }
        ]
      };
      chart.setOption(option);

      // 将图表实例存储起来，以便后续操作
      this.charts[chartKey] = chart;
    },
    // 判断是否为 URL
    isUrl(string) {
      return string.startsWith('http://') || string.startsWith('https://');
    },
    // 获取菜单的图标
    getMenuIcon(menu_id) {
      const menu = this.menus.find(menu => menu.id === menu_id);
      return menu ? menu.icon : '';
    },
    // 获取菜单图标颜色
    getMenuIconColor(menu_id) {
      const menu = this.menus.find(menu => menu.id === menu_id);
      return menu ? menu.icon_color : '';
    },
    getMenuTitle(menu_id) {
      const menu = this.menus.find(menu => menu.id === menu_id);
      return menu ? menu.title : '未指定';
    },
    fetchDashboardData() {
      const token = this.$store.state.token;
      axios.all([
        axios.get(`${process.env.VUE_APP_API_URL}/users/total`, {
          headers: { Authorization: `Bearer ${token}` }
        }),
        axios.get(`${process.env.VUE_APP_API_URL}/applications/total`, {
          headers: { Authorization: `Bearer ${token}` }
        }),
        axios.get(`${process.env.VUE_APP_API_URL}/menus/total`, {
          headers: { Authorization: `Bearer ${token}` }
        }),
        axios.get(`${process.env.VUE_APP_API_URL}/applications/recent`, {
          headers: { Authorization: `Bearer ${token}` }
        }),
        // 获取所有菜单，确保没有分页限制，使用足够大的 pageSize
        axios.get(`${process.env.VUE_APP_API_URL}/menus`, {
          params: {
            pageSize: 1000, // 获取所有菜单数据，假设 1000 足够大
          },
          headers: { Authorization: `Bearer ${token}` }
        })
      ]).then(axios.spread((usersResponse, applicationsResponse, menusResponse, recentApplicationsResponse, allMenusResponse) => {
        this.totalUsers = usersResponse.data.total;
        this.totalApplications = applicationsResponse.data.total;
        this.totalMenus = menusResponse.data.total;
        this.recentApplications = recentApplicationsResponse.data.applications;
        this.menus = allMenusResponse.data.menus; // 获取所有菜单

        // 计算百分比
        this.applicationsPercentage = this.calculatePercentage(this.totalApplications);
        this.menusPercentage = this.calculatePercentage(this.totalMenus);
        this.usersPercentage = this.calculatePercentage(this.totalUsers);

        // 更新图表
        this.initCharts();
      })).catch(error => {
        console.error('Error fetching dashboard data:', error);
      });
    },
    calculatePercentage(value) {
      const maxValue = 500; // 你可以定义一个合理的最大值作为百分比的基准
      return parseFloat(Math.min((value / maxValue) * 100, 100).toFixed(1));
    }
  }
};
</script>


<style>
h3 {
  margin-bottom: 20px;
}
.dashboard-row {
  margin-bottom: 20px; /* 控制 el-row 之间的间距 */
}

.dashboard-card {
  padding: 15px; /* 你可以调整 padding 或者 margin 来让卡片有更多的空间 */
}
</style>
