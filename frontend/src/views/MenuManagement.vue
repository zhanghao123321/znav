<template>
  <div class="filter-container">
    <!-- 筛选部分 -->
    <div class="filter-item">
      <label for="title">标题</label>
      <el-input
          id="title"
          v-model="filters.title"
          placeholder="请输入标题"
      />
    </div>
    <div class="filter-item">
      <label for="status">状态</label>
      <el-select
          id="status"
          v-model="filters.status"
          placeholder="请选择状态"
          clearable
      >
        <el-option
            label="启用"
            value="active"
        />
        <el-option
            label="停用"
            value="inactive"
        />
      </el-select>
    </div>
    <el-button
        type="primary"
        @click="handleSearch"
    >
      <icon
          :icon="'mdi:magnify'"
          width="20"
          height="20"
      />
      <span class="button-text">查询</span>
    </el-button>

    <el-button @click="handleReset">
      <icon
          :icon="'mdi:refresh'"
          width="20"
          height="20"
      />
      <span class="button-text">重置</span>
    </el-button>
  </div>

  <div class="header">
    <div class="header-buttons">
      <el-button
          type="primary"
          class="add-menu-btn"
          @click="openForm('add')"
      >
        添加菜单
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
  <div
      v-if="formattedMenus.length > 0"
      class="menu-table-container"
  >
    <el-table
        :data="formattedMenus"
        border
        stripe
        @selection-change="handleSelectionChange"
    >
      <el-table-column
          type="selection"
          width="55"
      />
      <el-table-column
          prop="id"
          label="ID"
          width="100"
          align="center"
          show-overflow-tooltip
      >
        <template #default="scope">
          <div style="display: flex; align-items: center; justify-content: space-between; padding-left: 10px;">
            <div style="display: flex; align-items: center;">
              <template v-if="scope.row.hasChildren">
                <el-button
                    link
                    style="padding: 0; margin-right: -55px;"
                    @click="toggleMenu(scope.row.id)"
                >
                  <!-- 调整 margin 来控制箭头的位置 -->
                  <el-icon>
                    <template v-if="scope.row.expanded">
                      <!-- 展开时显示自定义的向下箭头 -->
                      <div style="margin-right: 20px;">
                        <icon
                            :icon="'mingcute:down-line'"
                            width="14"
                            height="14"
                            color="black"
                        />
                      </div>
                    </template>
                    <template v-else>
                      <!-- 收起时显示自定义的向右箭头 -->
                      <div style="margin-right: 20px;">
                      <icon
                          :icon="'mingcute:right-line'"
                          width="14"
                          height="14"
                          color="black"
                      />
                      </div>
                    </template>
                  </el-icon>
                </el-button>
              </template>
            </div>
            <div style="text-align: center; flex-grow: 1;">
              <!-- 使ID列在父容器内居中 -->
              <span>{{ scope.row.id }}</span>
            </div>
          </div>
        </template>
      </el-table-column>
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
          <!-- 判断是否为 URL -->
          <template v-if="isUrl(scope.row.icon)">
            <img
                :src="scope.row.icon"
                :style="{ color: scope.row.icon_color || '#000' }"
                alt="菜单图标"
                class="menu-icon"
            >
          </template>
          <!-- 如果不是 URL，则使用 Iconify 图标 -->
          <template v-else>
            <icon
                :icon="scope.row.icon"
                :color="scope.row.icon_color || '#000'"
                width="30"
                height="30"
            />
          </template>
        </template>
      </el-table-column>
      <!-- 新增的排序列 -->
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
          label="状态"
          width="200"
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
                  @click="deleteMenu(scope.row.id)"
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
        :total="totalMenus"
        :page-size="pageSize"
        :current-page="currentPage"
        :page-sizes="pageSizeOptions"
        @current-change="handlePageChange"
        @size-change="handlePageSizeChange"
    />
  </div>

  <!-- 表单部分（使用弹出框展示） -->
  <el-dialog
      :model-value="showForm"
      title="菜单管理"
      class="menu-dialog"
      @close="cancelForm"
  >
    <el-form
        :model="menu"
        label-width="100px"
    >
      <el-row :gutter="20">
        <el-col :span="24">
          <el-form-item label="标题">
            <el-input
                v-model="menu.title"
                placeholder="请输入菜单标题"
                required
            />
          </el-form-item>
        </el-col>

        <!-- 调整后的“图标”表单项 -->
        <el-col :span="24">
          <el-form-item label="图标">
            <el-row :gutter="5">
              <!-- 图标输入框 -->
              <el-col :span="18">
                <el-input
                    v-model="menu.icon"
                    placeholder="请输入iconify图标或URL"
                    required
                    class="icon-input"
                />
              </el-col>
              <!-- 图标预览 -->
              <el-col :span="2" class="ch-padding">
                <!-- 判断是否为 URL -->
                <template v-if="isUrl(menu.icon)">
                  <img
                      :src="menu.icon"
                      :style="{ color: menu.icon_color || '#000' }"
                      alt="菜单图标"
                      class="menu-icon"
                  >
                </template>
                <!-- 如果不是 URL，则使用 Iconify 图标 -->
                <template v-else>
                  <icon
                      :icon="menu.icon"
                      :color="menu.icon_color || '#000'"
                      alt="菜单图标"
                      class="menu-icon"
                  />
                </template>
              </el-col>
              <!-- 颜色选择器 -->
              <el-col :span="2">
                <el-color-picker v-model="menu.icon_color" />
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
          <el-form-item label="父级菜单">
            <el-select
                v-model="menu.parent_id"
                placeholder="请选择父级菜单"
                clearable
            >
              <el-option
                  v-for="parent in parentMenus"
                  :key="parent.id"
                  :label="parent.title"
                  :value="parent.id"
              >
                <template #default>
                  <span style="display: flex; align-items: center;">
                    <img
                        v-if="isUrl(parent.icon)"
                        :src="parent.icon"
                        alt="menu-icon"
                        style="width: 20px; height: 20px; margin-right: 8px;"
                    >
                    <icon
                        v-else
                        :icon="parent.icon"
                        width="20"
                        height="20"
                        :style="{ marginRight: '8px', color: parent.icon_color || '#000' }"
                    />
                    <span>{{ parent.title }}</span>
                  </span>
                </template>
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>

        <el-col :span="24">
          <el-form-item label="状态">
            <el-switch
                v-model="menu.status"
                active-value="active"
                inactive-value="inactive"
                active-text="启用"
                inactive-text="禁用"
                active-color="#409eff"
                inactive-color="#909399"
            />
          </el-form-item>
        </el-col>
        <el-col :span="24">
          <el-form-item label="排序">
            <el-input-number
                v-model="menu.order_id"
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
        <el-button @click="resetForm">
          重置
        </el-button>
        <el-button @click="cancelForm">
          取消
        </el-button>
        <el-button
            type="primary"
            @click="submitMenu"
        >
          提交
        </el-button>
      </div>
    </template>
  </el-dialog>
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
      originalMenu: {}, // 用于保存初始状态的 menu 对象
      menu: {
        title: '',
        icon: '',
        icon_color: '#000000', // 默认图标颜色
        status: 'active',
        order_id: 0,
        parent_id: null, // 父级菜单ID，null表示顶级菜单
      },
      menus: [],
      formattedMenus: [], // 用于存储格式化后的菜单数据
      parentMenus: [], // 用于存储可供选择的父级菜单
      expandedIds: new Set(), // 存储已展开的菜单ID
      currentPage: 1, // 当前页码
      pageSize: 10, // 每页显示的菜单数
      totalMenus: 0, // 菜单总数
      pageSizeOptions: [10, 20, 30, 40], // 每页显示条数的选项
      multipleSelection: [], // 存储多选的菜单
      filters: {
        title: '', // 标题筛选
        status: '', // 状态筛选
      },
      icon_color: '#000000', // 查询和重置按钮的图标颜色
    };
  },
  created() {
    this.fetchMenus();
  },
  methods: {
    isUrl(string) {
      return string.startsWith('http://') || string.startsWith('https://');
    },
    fetchAllMenus() {
      // 获取所有菜单数据，不分页
      axios.get(`${process.env.VUE_APP_API_URL}/menus`, {
        params: {
          // 如果 API 支持传递一个大的 pageSize 来获取所有数据，这里可以指定一个足够大的值
          pageSize: 1000,
        },
        headers: { Authorization: `Bearer ${this.$store.state.token}` }
      })
          .then(response => {
            this.parentMenus = response.data.menus.filter(menu => menu.parent_id === null);
          })
          .catch(error => {
            console.error('Error fetching all menus:', error);
          });
    },
    fetchMenus() {
      axios.get(`${process.env.VUE_APP_API_URL}/menus`, {
        params: {
          title: this.filters.title, // 传递筛选的标题
          status: this.filters.status, // 传递筛选的状态
          pageSize: 1000, // 假设 1000 是一个足够大的值，可以取到所有菜单
        },
        headers: { Authorization: `Bearer ${this.$store.state.token}` }
      })
          .then(response => {
            this.menus = response.data.menus.sort((a, b) => a.order_id - b.order_id);
            this.totalMenus = this.menus.length; // 更新总菜单数
            this.formatMenus(); // 格式化所有菜单数据
            this.populateParentMenus(); // 填充父级菜单
          })
          .catch(error => {
            console.error('Error fetching menus:', error);
          });
    },
    formatMenus() {
      const formatMenuList = (menus, parentId = null, level = 0) => {
        return menus
            .filter(menu => menu.parent_id === parentId)
            .map(menu => {
              const children = formatMenuList(menus, menu.id, level + 1);
              return {
                ...menu,
                level, // 添加层级信息
                hasChildren: children.length > 0,
                expanded: this.expandedIds.has(menu.id),
                children,
              };
            });
      };

      const flattenMenuList = (menus) => {
        return menus.reduce((acc, menu) => {
          acc.push(menu);
          if (menu.expanded && menu.children.length > 0) {
            acc.push(...flattenMenuList(menu.children));
          }
          return acc;
        }, []);
      };

      const formatted = formatMenuList(this.menus);
      this.formattedMenus = flattenMenuList(formatted);
    },
    populateParentMenus() {
      // 父级菜单只允许选择没有父级的菜单，避免循环嵌套
      this.parentMenus = this.menus.filter(menu => menu.parent_id === null);
    },
    toggleMenu(id) {
      if (this.expandedIds.has(id)) {
        this.expandedIds.delete(id);
      } else {
        this.expandedIds.add(id);
      }
      this.formatMenus(); // 重新格式化数据以反映展开状态的改变
    },
    handleSearch() {
      this.currentPage = 1; // 每次查询时重置到第一页
      this.fetchMenus();
    },
    handleReset() {
      this.filters = {
        title: '',
        status: '',
      };
      this.currentPage = 1;
      this.fetchMenus();
    },
    handleSelectionChange(val) {
      this.multipleSelection = val; // 更新选择项
    },
    handleBatchDelete() {
      if (this.multipleSelection.length === 0) return;

      this.$confirm('此操作将永久删除所选菜单, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
          .then(() => {
            const ids = this.multipleSelection.map(item => item.id);
            axios.post(`${process.env.VUE_APP_API_URL}/menus/batch_delete`, { ids }, {
              headers: { Authorization: `Bearer ${this.$store.state.token}` }
            })
                .then(() => {
                  this.fetchMenus(); // 刷新数据
                  this.multipleSelection = []; // 清空选择项
                  this.$message.success('菜单已删除'); // 批量删除成功提示
                })
                .catch(error => {
                  console.error('Error deleting menus:', error);
                });
          })
          .catch(() => {
            this.$message.info('已取消删除');
          });
    },
    handlePageChange(page) {
      this.currentPage = page;
      this.fetchMenus(); // 页码变化时重新获取数据
    },
    handlePageSizeChange(size) {
      this.pageSize = size;
      this.currentPage = 1; // 重置到第一页
      this.fetchMenus(); // 页面大小变化时重新获取数据
    },
    openForm(action, menu = null) {
      this.isEditing = action === 'edit';
      if (this.isEditing && menu) {
        this.menu = { ...menu };  // 确保menu对象中包含order_id字段
        this.originalMenu = { ...menu }; // 保存初始状态
      } else {
        this.resetForm();
      }
      this.showForm = true;
    },
    hasChanges() {
      // 比较当前 menu 对象与原始 menu 对象的值
      return Object.keys(this.menu).some(
          key => this.menu[key] !== this.originalMenu[key]
      );
    },
    submitMenu() {
      if (this.isEditing && this.hasChanges()) {
        axios.put(`${process.env.VUE_APP_API_URL}/menus/${this.menu.id}`, this.menu, {
          headers: { Authorization: `Bearer ${this.$store.state.token}` }
        })
            .then(() => {
              this.fetchMenus(); // 确保提交后重新获取菜单数据
              this.showForm = false;
              this.resetForm();
              this.$message.success('菜单已更新');
            })
            .catch(error => {
              console.error('Error updating menu:', error);
              this.$message.error('更新菜单时出错');
            });
      }
      else if (!this.isEditing) {
        axios.post(`${process.env.VUE_APP_API_URL}/menus`, this.menu, {
          headers: { Authorization: `Bearer ${this.$store.state.token}` }
        })
            .then(() => {
              this.fetchMenus(); // 确保提交后重新获取菜单数据
              this.showForm = false;
              this.resetForm();
              this.$message.success('菜单已添加');
            })
            .catch(error => {
              console.error('Error adding menu:', error);
              this.$message.error('添加菜单时出错');
            });
      }
      else {
        this.$message.info('未检测到任何更改');
      }
    },
    deleteMenu(id) {
      this.$confirm('此操作将永久删除该菜单, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
          .then(() => {
            axios.delete(`${process.env.VUE_APP_API_URL}/menus/${id}`, {
              headers: { Authorization: `Bearer ${this.$store.state.token}` }
            })
                .then(() => {
                  this.fetchMenus();
                  this.$message.success('菜单已删除'); // 删除菜单提示
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
      this.menu = { title: '', icon: '', icon_color: '#000000', status: 'active', order_id: 0, parent_id: null };
      this.originalMenu = {}; // 重置初始状态
      this.isEditing = false;
    }
  }
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

.add-menu-btn {
  background-color: transparent !important;
  color: rgba(64,158,255,0.95) !important;
  padding: 10px 20px !important;
  border-radius: 10px !important;
  font-size: 14px !important;
  transition: all 0.3s ease !important;
  box-shadow: 0 1px 5px rgba(64,158,255,0.53) !important;
}

.add-menu-btn:hover {
  background-color: rgba(64,158,255,0.95) !important;
  color: #fff !important;
  box-shadow: 0 4px 12px rgba(64,158,255,0.5);
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

.menu-dialog .el-dialog__body {
  padding: 20px;
}

.menu-dialog .el-form-item__label {
  width: 100px;
}

.menu-dialog .el-row {
  margin-left: 0;
  margin-right: 0;
}

.icon-link-container {
  margin-top: 15px;
  margin-left: -7px;
}

.icon-link {
  font-size: 12px;
  color: #409EFF;
}
.color-picker-col {
  margin-left: 10px;
}

.filter-item .el-input,
.filter-item .el-select {
  width: 300px; /* 增加输入框和选择框的宽度 */
}

/* 对话框底部按钮 */
.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 1px;
}

.menu-table-container {
  margin-top: 20px;
  background-color: #fff;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  overflow: auto !important;
  padding-bottom: 60px;
}

.menu-icon {
  width: 30px;
  height: 30px;
  object-fit: cover;
  border-radius: 100%;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* 覆盖 Element Plus 表格样式 */
.menu-table-container .el-table .cell {
  white-space: normal !important; /* 允许内容换行 */
  word-wrap: break-word !important; /* 强制长单词或URL换行 */
  overflow-wrap: break-word !important; /* 处理长字符的换行 */
  word-break: break-all !important; /* 在必要时打断单词换行 */
  overflow: hidden !important; /* 防止内容溢出 */
  text-overflow: ellipsis !important; /* 如果溢出，显示省略号 */
  display: block !important; /* 确保块级显示，处理表格内文本 */
  height: auto !important; /* 允许行高自动调整 */
  line-height: 30px !important;
}

.text-wrap {
  display: inline-block;
  white-space: normal;
  word-wrap: break-word;
  overflow-wrap: break-word;
  word-break: break-all;
  max-width: 100%;
  line-height: 1.5; /* 保持行距一致 */
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
  justify-content: center; /* 水平居中 */
  align-items: center;     /* 垂直居中 */
  gap: 10px;               /* 按钮之间的间距 */
}

/* 修改按钮的样式，使其高度和内边距一致 */
.edit-btn,
.delete-btn {
  display: flex;
  align-items: center;       /* 垂直居中图标和文字 */
  padding: 5px 10px;         /* 调整内边距 */
  font-size: 14px;           /* 统一字体大小 */
}

/* 确保按钮的图标和文字在同一行 */
.edit-btn i,
.delete-btn i {
  margin-right: 5px;
}

/* 保持原有的颜色和效果 */
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

.pagination-container {
  display: flex;
  justify-content: flex-end;
  position: fixed;
  bottom: 0;  /* 距离页面底部 0px */
  right: 0;  /* 距离页面右边 0px */
  width: 100%;  /* 占满页面宽度 */
  padding: 10px 20px;  /* 增加一些内边距 */
  background-color: #fff;  /* 背景颜色设置为白色或与你页面匹配的颜色 */
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);  /* 添加阴影效果使其与内容分开 */
  z-index: 100;
}

.filter-container {
  display: flex;
  align-items: center;
  margin-bottom: 2%;
}

.filter-item {
  display: flex;
  align-items: center;
  margin-right: 15px; /* 增加右边距以保持间距 */
}

.filter-item label {
  margin-right: 5px; /* 标签与输入框之间的间距 */
  font-size: 15px; /* 标签的字体大小 */
  color: #606266; /* 标签的字体颜色 */
  white-space: nowrap; /* 确保标签不会换行 */
}

.filter-item .el-input,
.filter-item .el-select {
  width: 200px; /* 调整输入框和选择框的宽度 */
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

.color-picker-container {
  padding-left: 10px;
}

.icon-input .el-input__inner {
  margin-right: 10px; /* 根据需要调整 */
}

.el-color-dropdown__btns {
  display: flex;
  margin-top: 12px;
  align-items: flex-end;
}

.el-color-dropdown__btns .el-button {
  margin-left: 10px;
}

.ch-padding {
  padding-left: 10px !important;
  padding-right: 3px !important;
}
</style>
