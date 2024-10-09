<template>
  <div>
    <div class="filter-container">
      <!-- 筛选部分 -->
      <div class="filter-item">
        <label for="title">标题</label>
        <el-input
            id="title"
            v-model="filters.title"
            placeholder="请输入标题"
            @keydown.enter="handleSearch"
        />
      </div>
      <div class="filter-item">
        <label for="status">状态</label>
        <el-select
            id="status"
            v-model="filters.status"
            placeholder="请选择状态"
            @keydown.enter="handleSearch"
            clearable
        >
          <el-option label="启用" value="active" />
          <el-option label="停用" value="inactive" />
        </el-select>
      </div>

      <div class="filter-item">
        <el-cascader
            id="menu"
            v-model="filters.menu_id"
            :options="menuOptions"
            placeholder="请选择菜单"
            clearable
            :props="{ expandTrigger: 'hover', emitPath: false, checkStrictly: true }"
        >
          <template #default="{ data }">
            <span style="display: flex; align-items: center;">
              <img
                  v-if="isUrl(data.icon)"
                  :src="data.icon"
                  width="20"
                  height="20"
                  alt="图标"
                  style="margin-right: 8px;"
              />
              <icon
                  v-else
                  :icon="data.icon"
                  :style="{ marginRight: '8px', color: data.icon_color || '#000' }"
                  width="20"
                  height="20"
                  alt="图标"
                  style="margin-right: 8px;"
              />
              <span>{{ data.label }}</span>
            </span>
          </template>
        </el-cascader>
      </div>

      <el-button type="primary" @click="handleSearch">
        <icon icon="mdi:magnify" width="20" height="20" />
        <span class="button-text">查询</span>
      </el-button>

      <el-button @click="handleReset">
        <icon icon="mdi:refresh" width="20" height="20" />
        <span class="button-text">重置</span>
      </el-button>
    </div>

    <div class="header">
      <div class="header-buttons">
        <el-button
            type="primary"
            class="add-app-btn"
            @click="openForm('add')"
        >
          添加应用
        </el-button>
        <el-button
            type="danger"
            class="batch-delete-btn"
            :disabled="multipleSelection.length === 0"
            @click="handleBatchDelete"
        >
          批量删除
        </el-button>
      </div>
    </div>

    <!-- 数据展示部分 -->
    <div v-if="applications.length > 0" class="app-table-container">
      <el-table
          :data="applications"
          border
          stripe
          @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column
            prop="id"
            label="ID"
            width="100"
            align="center"
            show-overflow-tooltip
        />
        <el-table-column
            prop="title"
            label="标题"
            width="200"
            align="center"
            show-overflow-tooltip
        >
          <template #default="scope">
            <span class="text-wrap">{{ scope.row.title }}</span>
          </template>
        </el-table-column>
        <el-table-column
            label="图标"
            width="150"
            align="center"
            show-overflow-tooltip
        >
          <template #default="scope">
            <!-- 如果是 URL，使用 <img> 标签渲染 -->
            <template v-if="isUrl(scope.row.icon)">
              <img
                  :src="scope.row.icon"
                  :style="{ color: scope.row.icon_color || '#000' }"
                  width="30"
                  height="30"
                  alt="图标"
                  style="margin-right: 8px;"
              />
            </template>
            <!-- 否则，使用 <icon> 组件渲染 Iconify 图标 -->
            <template v-else>
              <icon
                  :icon="scope.row.icon"
                  :color="scope.row.icon_color || '#000'"
                  width="30"
                  height="30"
                  alt="图标"
                  style="margin-right: 8px;"
              />
            </template>
          </template>
        </el-table-column>
        <el-table-column
            prop="link"
            label="链接"
            width="220"
            align="center"
            show-overflow-tooltip
        >
          <template #default="scope">
            <span class="text-wrap">{{ scope.row.link }}</span>
          </template>
        </el-table-column>
        <el-table-column
            prop="menu_id"
            label="菜单"
            width="200"
            align="center"
            show-overflow-tooltip
        >
          <template #default="scope">
            <div
                v-if="scope && scope.row"
                style="display: flex; align-items: center; padding-left: 20px;"
            >
              <template v-if="isUrl(getMenuIcon(scope.row.menu_id))">
                <img
                    :src="getMenuIcon(scope.row.menu_id)"
                    :style="{ color: getMenuIconColor(scope.row.menu_id) || '#000' }"
                    width="20"
                    height="20"
                    alt="图标"
                    style="margin-right: 8px;"
                />
              </template>
              <template v-else>
                <icon
                    :icon="getMenuIcon(scope.row.menu_id)"
                    :color="getMenuIconColor(scope.row.menu_id) || '#000'"
                    width="20"
                    height="20"
                    alt="图标"
                    style="margin-right: 8px;"
                />
              </template>
              <span>{{ getMenuTitle(scope.row.menu_id) }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column
            label="状态"
            width="150"
            align="center"
            show-overflow-tooltip
        >
          <template #default="scope">
            <el-tag :type="scope.row.status === 'active' ? 'success' : 'danger'">
              {{ scope.row.status === 'active' ? '启用' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column
            prop="order_id"
            label="排序"
            width="150"
            align="center"
            show-overflow-tooltip
        >
          <template #default="scope">
            <span>{{ scope.row.order_id }}</span>
          </template>
        </el-table-column>
        <el-table-column
            label="创建时间"
            width="200"
            align="center"
            show-overflow-tooltip
        >
          <template #default="scope">
            <span>{{ new Date(scope.row.created_at).toLocaleString() }}</span>
          </template>
        </el-table-column>
        <el-table-column
            label="操作"
            width="150"
            align="center"
            fixed="right"
            show-overflow-tooltip
        >
          <template #default="scope">
            <div class="action-buttons">
              <el-tooltip content="编辑" placement="top">
                <el-button
                    link
                    class="edit-btn"
                    @click="openForm('edit', scope.row)"
                >
                  <i class="el-icon-edit" /> 编辑
                </el-button>
              </el-tooltip>
              <el-tooltip content="删除" placement="top">
                <el-button
                    link
                    class="delete-btn"
                    @click="deleteApp(scope.row.id)"
                >
                  <i class="el-icon-delete" /> 删除
                </el-button>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 分页器 -->
    <div class="pagination-container">
      <el-pagination
          background
          layout="total, sizes, prev, pager, next, jumper"
          :total="totalApplications"
          :page-size="pageSize"
          :current-page="currentPage"
          :page-sizes="pageSizeOptions"
          @current-change="handlePageChange"
          @size-change="handlePageSizeChange"
      />
    </div>

    <!-- 表单部分 -->
    <el-dialog
        :model-value="showForm"
        title="应用管理"
        class="app-dialog"
        @close="cancelForm"
    >
      <el-form :model="app" label-width="80px">
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="链接">
              <el-input
                  v-model="app.link"
                  placeholder="请输入应用链接"
                  required
              />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label=" ">
              <el-button type="primary" @click="fetchWebsiteData" :loading="isFetching">
                采集
              </el-button>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="标题">
              <el-input
                  v-model="app.title"
                  placeholder="请输入应用标题"
                  required
              />
            </el-form-item>
          </el-col>

          <!-- 图标输入和预览 -->
          <el-col :span="24">
            <el-form-item label="图标" >
              <el-row :gutter="5">
                <!-- 图标输入框 -->
                <el-col :span="18">
                  <el-input
                      v-model="app.icon"
                      placeholder="请输入iconify图标或URL"
                      required
                      class="icon-input"
                  />
                </el-col>
                <!-- 同步图床按钮 -->
                <el-col :span="2">
                  <el-tooltip content="同步图标到图床" placement="top">
                    <el-button
                        @click="syncIconToImageHost"
                        :disabled="!isUrl(app.icon) || isSyncingIcon"
                        type="text"
                    >
                      <template v-if="isSyncingIcon">
                        <div style="margin-left: -13px; margin-top: 5px;">
                          <icon
                              icon="eos-icons:loading"
                              spin
                              width="40"
                              height="40"
                              color="#00bfff"
                          />
                        </div>
                      </template>
                      <template v-else>
                        <div style="margin-left: -13px; margin-top: 5px;">
                          <icon
                              icon="fluent:arrow-sync-circle-16-regular"
                              width="40"
                              height="40"
                              color="#00bfff"
                          />
                        </div>
                      </template>
                    </el-button>
                  </el-tooltip>
                </el-col>
                <!-- 图标预览 -->
                <el-col :span="2">
                  <div style="margin-top: 1.8px;" >
                    <!-- 判断是否为 URL -->
                    <template v-if="isUrl(app.icon)">
                      <img
                          :src="app.icon"
                          :style="{ color: app.icon_color || '#000' }"
                          width="30"
                          height="30"
                          alt="图标"/>
                    </template>
                    <!-- 如果不是 URL，则使用 Iconify 图标 -->
                    <template v-else>
                      <icon
                          :icon="app.icon"
                          :color="app.icon_color || '#000'"
                          width="30"
                          height="30"
                      />
                    </template>
                  </div>
                </el-col>
                <!-- 颜色选择器 -->
                <el-col :span="2">
                  <div style="margin-left: -3px; margin-top: 1px;" >
                    <el-color-picker v-model="app.icon_color" />
                  </div>
                </el-col>
              </el-row>
              <el-col :span="24">
                <div class="icon-link-container">
                  <a
                      href="https://icon-sets.iconify.design/?category=General"
                      target="_blank"
                      class="icon-link"
                  >
                    点我前往 Iconify 查看图标
                  </a>
                </div>
              </el-col>
            </el-form-item>
          </el-col>

          <el-col :span="24">
            <el-form-item label="描述">
              <el-input
                  v-model="app.description"
                  type="textarea"
                  placeholder="请输入应用描述"
                  required
              />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="状态">
              <el-switch
                  v-model="app.status"
                  active-value="active"
                  inactive-value="inactive"
                  active-text="启用"
                  inactive-text="禁用"
                  active-color="#409EFF"
                  inactive-color="#909399"
              />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="菜单">
              <el-cascader
                  v-model="app.menu_id"
                  :options="menuOptions"
                  placeholder="请选择菜单"
                  clearable
                  :props="{
                  expandTrigger: 'hover',
                  emitPath: false,
                  checkStrictly: true,
                }"
              >
                <template #default="{ data }">
                  <span style="display: flex; align-items: center;">
                    <img
                        v-if="isUrl(data.icon)"
                        :src="data.icon"
                        alt="app-icon"
                        style="width: 20px; height: 20px; margin-right: 8px;"
                    />
                    <icon
                        v-else
                        :icon="data.icon"
                        width="20"
                        height="20"
                        :style="{ marginRight: '8px', color: data.icon_color || '#000' }"
                    />
                    <span>{{ data.label }}</span>
                  </span>
                </template>
              </el-cascader>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="排序">
              <el-input-number
                  v-model="app.order_id"
                  :min="-100"
                  :max="100"
                  placeholder=""
              />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="resetForm">重置</el-button>
          <el-button @click="cancelForm">取消</el-button>
          <el-button type="primary" @click="submitApp">
            提交
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { Icon } from '@iconify/vue';
import axios from 'axios';

export default {
  components: {
    Icon,
  },
  data() {
    return {
      showForm: false,
      isEditing: false,
      originalApp: {},
      isFetching: false,
      isSyncingIcon: false, // 同步图标的加载状态
      app: {
        title: '',
        icon: '', // 这里将存储用户从 Iconify 中选择的图标名称或URL
        icon_color: '#000000', // 默认图标颜色
        link: '',
        description: '',
        status: 'active',
        menu_id: '',
        order_id: 0,
      },
      applications: [],
      menus: [],
      menuOptions: [],
      currentPage: 1,
      pageSize: 10,
      totalApplications: 0,
      pageSizeOptions: [10, 20, 30, 40],
      multipleSelection: [],
      filters: {
        title: '',
        status: '',
        menu_id: '',
      },
    };
  },
  watch: {
    selectedMenuId: {
      immediate: true,
      handler() {
        this.fetchApplications();
      },
    },
  },
  created() {
    this.fetchMenus();
  },
  methods: {
    initializeMenus() {
      // 过滤出有子菜单的一级菜单
      this.parentMenus = this.menus.filter(
          (menu) => menu.children && menu.children.length > 0
      );
    },
    isUrl(string) {
      return string.startsWith('http://') || string.startsWith('https://');
    },
    getMenuIcon(menu_id) {
      const menu = this.menus.find((menu) => menu.id === menu_id);
      return menu ? menu.icon : '';
    },
    // 获取菜单图标颜色
    getMenuIconColor(menu_id) {
      const menu = this.menus.find((menu) => menu.id === menu_id);
      return menu ? menu.icon_color : '';
    },
    // 获取菜单标题
    getMenuTitle(menu_id) {
      const menu = this.menus.find((menu) => menu.id === menu_id);
      return menu ? menu.title : '未指定';
    },
    fetchApplications() {
      axios
          .get(`${process.env.VUE_APP_API_URL}/applications`, {
            params: {
              page: this.currentPage,
              pageSize: this.pageSize,
              title: this.filters.title,
              status: this.filters.status,
              menuId: this.filters.menu_id, // 使用 filters.menu_id
            },
            headers: { Authorization: `Bearer ${this.$store.state.token}` },
          })
          .then((response) => {
            // 处理响应数据的逻辑
            const uniqueApplications = Array.from(
                new Set(response.data.applications.map((app) => app.id))
            ).map((id) =>
                response.data.applications.find((app) => app.id === id)
            );

            this.applications = uniqueApplications.sort(
                (a, b) => a.menu_id - b.menu_id
            );
            this.totalApplications = response.data.total;
          })
          .catch((error) => {
            console.error('Error fetching applications:', error);
          });
    },

    // 获取菜单数据并格式化为 el-cascader 所需的结构
    fetchMenus() {
      axios
          .get(`${process.env.VUE_APP_API_URL}/menus`, {
            params: {
              pageSize: 1000, // 获取所有菜单
            },
            headers: { Authorization: `Bearer ${this.$store.state.token}` },
          })
          .then((response) => {
            this.menus = response.data.menus;
            this.populateParentMenus(); // 将菜单数据转换为 cascader 所需格式
          })
          .catch((error) => {
            console.error('Error fetching menus:', error);
          });
    },

    // 将菜单数据转换为 el-cascader 组件所需的格式
    populateParentMenus() {
      this.menuOptions = this.menus
          .filter((menu) => menu.parent_id === null) // 只选取一级菜单
          .map((menu) => ({
            value: menu.id,
            label: menu.title,
            icon: menu.icon, // 添加图标
            icon_color: menu.icon_color, // 添加图标颜色
            children: this.menus
                .filter((submenu) => submenu.parent_id === menu.id)
                .map((submenu) => ({
                  value: submenu.id,
                  label: submenu.title,
                  icon: submenu.icon, // 添加二级菜单图标
                  icon_color: submenu.icon_color, // 添加二级菜单图标颜色
                })),
          }));
    },

    handleSearch() {
      this.currentPage = 1;
      this.fetchApplications();
    },
    handleReset() {
      this.filters = {
        title: '',
        status: '',
        menu_id: '',
      };
      this.currentPage = 1;
      this.fetchApplications();
    },
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    handleBatchDelete() {
      if (this.multipleSelection.length === 0) return;

      this.$confirm('此操作将永久删除所选应用, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
          .then(() => {
            const ids = this.multipleSelection.map((item) => item.id);
            axios
                .post(
                    `${process.env.VUE_APP_API_URL}/applications/batch_delete`,
                    { ids },
                    {
                      headers: { Authorization: `Bearer ${this.$store.state.token}` },
                    }
                )
                .then(() => {
                  this.fetchApplications();
                  this.multipleSelection = [];
                  this.$message.success('应用已删除');
                })
                .catch((error) => {
                  console.error('Error deleting applications:', error);
                });
          })
          .catch(() => {
            this.$message.info('已取消删除');
          });
    },
    handlePageChange(page) {
      this.currentPage = page;
      this.fetchApplications();
    },
    handlePageSizeChange(size) {
      this.pageSize = size;
      this.currentPage = 1;
      this.fetchApplications();
    },
    hasChanges() {
      return Object.keys(this.app).some(
          (key) => this.app[key] !== this.originalApp[key]
      );
    },
    submitApp() {
      // 检查是否选择了一个菜单
      if (!this.app.menu_id) {
        this.$message.error('请选择一个菜单');
        return;
      }

      // 判断是编辑操作且有更改
      if (this.isEditing && this.hasChanges()) {
        axios
            .put(
                `${process.env.VUE_APP_API_URL}/applications/${this.app.id}`,
                this.app,
                {
                  headers: { Authorization: `Bearer ${this.$store.state.token}` },
                }
            )
            .then(() => {
              this.fetchApplications();
              this.$message.success('应用已更新');
              this.resetForm();
              this.showForm = false;
            })
            .catch((error) => {
              console.error('Error submitting application:', error);
            });
      }
      // 判断是添加操作
      else if (!this.isEditing) {
        axios
            .post(`${process.env.VUE_APP_API_URL}/applications`, this.app, {
              headers: { Authorization: `Bearer ${this.$store.state.token}` },
            })
            .then(() => {
              this.fetchApplications();
              this.$message.success('应用已添加');
              this.resetForm();
              this.showForm = false;
            })
            .catch((error) => {
              console.error('Error submitting application:', error);
            });
      }
      // 没有更改的情况
      else {
        this.$message.info('未检测到任何更改');
      }
    },
    editApp(application) {
      this.app = { ...application };
      this.originalApp = { ...application };
      this.isEditing = true;
      this.showForm = true;
    },
    deleteApp(id) {
      this.$confirm('此操作将永久删除该应用, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
          .then(() => {
            axios
                .delete(`${process.env.VUE_APP_API_URL}/applications/${id}`, {
                  headers: { Authorization: `Bearer ${this.$store.state.token}` },
                })
                .then(() => {
                  this.fetchApplications();
                  this.$message.success('应用已删除');
                });
          })
          .catch(() => {
            this.$message.info('已取消删除');
          });
    },
    cancelForm() {
      this.resetForm();
      this.showForm = false;
    },
    resetForm() {
      this.app = {
        title: '',
        icon: '',
        icon_color: '#000000', // 重置颜色
        link: '',
        description: '',
        status: 'active',
        menu_id: '',
        order_id: 0,
      };
      this.originalApp = {};
      this.isEditing = false;
    },
    openForm(action, app = null) {
      if (action === 'edit' && app) {
        this.editApp(app);
      } else {
        this.resetForm();
        this.showForm = true;
      }
    },
    // 采集信息
    async fetchWebsiteData() {
      if (!this.app.link) {
        this.$message.error('请先输入应用链接');
        return;
      }

      // 检查链接是否有效
      if (!this.isUrl(this.app.link)) {
        this.$message.error('请输入有效的URL，如：https://www.baidu.com');
        return;
      }

      this.isFetching = true; // 开始加载
      try {
        const response = await axios.get(
            `${process.env.VUE_APP_API_URL}/scrape-website`,
            {
              params: { url: this.app.link },
              headers: { Authorization: `Bearer ${this.$store.state.token}` },
            }
        );

        const data = response.data;

        this.app.title = data.title || '';
        this.app.icon = data.logo_link || '';
        this.app.description = data.description || '';

        // 确保图标颜色有默认值
        this.app.icon_color = this.app.icon_color || '#000000';

        this.$message.success('采集成功，表单已自动填充');
      } catch (error) {
        console.error('Error fetching website data:', error);
        if (error.response) {
          switch (error.response.status) {
            case 400:
              this.$message.error('请求参数错误，请检查输入的链接');
              break;
            case 500:
              this.$message.error('服务器内部错误，请稍后再试');
              break;
            default:
              this.$message.error('采集失败，请稍后再试');
          }
        } else if (error.request) {
          this.$message.error('网络错误，请检查您的网络连接');
        } else {
          this.$message.error('发生错误：' + error.message);
        }
      } finally {
        this.isFetching = false; // 请求结束，重置加载状态
      }
    },
    async syncIconToImageHost() {
      if (!this.isUrl(this.app.icon)) {
        this.$message.error('当前图标不是有效的 URL，无法同步到图床');
        return;
      }

      this.isSyncingIcon = true;
      try {
        const response = await axios.post(
            `${process.env.VUE_APP_API_URL}/sync-icon`,
            { icon_url: this.app.icon },
            {
              headers: { Authorization: `Bearer ${this.$store.state.token}` },
            }
        );

        const data = response.data;
        this.app.icon = data.icon_url || '';
        this.$message.success('图标已成功同步到图床');
      } catch (error) {
        console.error('Error syncing icon to image host:', error);
        // 显示后端返回的错误信息
        if (error.response && error.response.data && error.response.data.error) {
          this.$message.error('同步图标失败：' + error.response.data.error);
        } else {
          this.$message.error('同步图标失败，请稍后再试');
        }
      } finally {
        this.isSyncingIcon = false;
      }
    },
  },
}
</script>

<style>
.header {
  margin-bottom: 20px;
}

.header-buttons {
  display: flex;
  align-items: center;
  gap: 10px; /* 按钮之间的间距 */
}

.add-app-btn {
  background-color: transparent !important;
  color: rgba(64, 158, 255, 0.95) !important;
  padding: 10px 20px !important;
  border-radius: 10px !important;
  font-size: 14px !important;
  transition: all 0.3s ease !important;
  box-shadow: 0 1px 5px rgba(64, 158, 255, 0.53) !important;
}

.add-app-btn:hover {
  background-color: rgba(64, 158, 255, 0.95) !important;
  color: #fff !important;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.5);
}

.batch-delete-btn {
  margin-left: 10px;
  background-color: transparent !important;
  color: #f56c6c !important;
  padding: 10px 20px !important;
  border-radius: 10px !important;
  font-size: 14px !important;
  transition: all 0.3s ease !important;
  box-shadow: 0 1px 5px rgba(245, 108, 108, 0.3) !important;
}

.batch-delete-btn:hover {
  background-color: #f56c6c !important;
  color: #fff !important;
  box-shadow: 0 4px 12px rgba(245, 108, 108, 0.5) !important;
}

.app-dialog .el-dialog__body {
  padding: 20px;
  background-color: #fff;
}

.app-dialog .el-form-item__label {
  color: #606266;
  width: 100px;
}

.app-dialog .el-input__inner,
.app-dialog .el-select {
  border-radius: 4px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.app-table-container {
  margin-top: 20px;
  background-color: #fff;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  overflow: auto !important;
  padding-bottom: 60px;
}

/* 覆盖 Element Plus 表格样式 */
.app-table-container .el-table .cell {
  white-space: normal !important;
  word-wrap: break-word !important;
  overflow-wrap: break-word !important;
  word-break: break-all !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  display: block !important;
  height: auto !important;
  line-height: 30px !important;
}

.text-wrap {
  display: inline-block;
  white-space: normal;
  word-wrap: break-word;
  overflow-wrap: break-word;
  word-break: break-all;
  max-width: 100%;
  line-height: 1.5;
}

.el-table .el-table__fixed {
  background-color: #fff;
}

.el-table .el-table__fixed-right {
  box-shadow: -2px 0 5px rgba(0, 0, 0, 0.1);
}

.el-table th {
  background-color: #f5f7fa;
  color: #606266;
}

.el-table tr {
  background-color: #ffffff;
}

.el-table tr:hover {
  background-color: #eef7ff;
}

.action-buttons {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
}

.edit-btn,
.delete-btn {
  display: flex;
  align-items: center;
  padding: 5px 10px;
  font-size: 14px;
}

.edit-btn i,
.delete-btn i {
  margin-right: 5px;
}

.edit-btn {
  color: rgba(64, 158, 255, 0.95) !important;
  border-radius: 5px;
  transition: all 0.3s ease;
  box-shadow: 0 1px 5px rgba(64, 158, 255, 0.53) !important;
}

.edit-btn:hover {
  color: #fff !important;
  background-color: rgba(64, 158, 255, 0.95) !important;
}

.delete-btn {
  color: #f56c6c !important;
  border-radius: 5px;
  transition: all 0.3s ease;
  box-shadow: 0 1px 5px rgba(245, 108, 108, 0.3) !important;
}

.delete-btn:hover {
  color: #fff !important;
  background-color: #f56c6c !important;
}

.pagination-container {
  display: flex;
  justify-content: flex-end;
  padding: 10px 20px;
  background-color: #fff;
  z-index: 100;
  position: relative; /* 相对布局，不影响表格宽度 */
}

.filter-container {
  display: flex;
  align-items: center;
  margin-bottom: 2%;
  overflow: auto; /* 当内容超出时显示滚动条 */
  white-space: nowrap; /* 确保内容不会换行 */
}

.filter-item {
  display: flex;
  align-items: center;
  margin-right: 15px;
}

.filter-item label {
  margin-right: 5px;
  font-size: 15px;
  color: #606266;
  white-space: nowrap;
}

.filter-item .el-input,
.filter-item .el-select {
  width: 200px;
}

.el-button {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 6px 12px;
}

.el-button .button-text {
  vertical-align: middle;
}

.icon-link-container {
  margin-top: 15px;
  margin-left: -7px;
}

.icon-link {
  font-size: 12px;
  color: #409EFF;
}

.el-color-dropdown__btns {
  display: flex;
  margin-top: 12px;
  align-items: flex-end;
}

.el-color-dropdown__btns .el-button {
  margin-left: 10px;
}

.app-icon {
  width: 35px !important;
  height: 35px !important;
  object-fit: cover;
  border-radius: 100%;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.el-color-picker__trigger{
  margin-right: 500px;
}
</style>
