<template>
  <div>
     <!-- 新規作成部分 -->
    <div class="row">
      <div class="col s10 m11">
        <input v-model="newTask" class="form-control" placeholder="Add your task!!">
      </div>
      <div class="col s2 m1">
        <div v-on:click="createTask" class="btn-floating waves-effect waves-light red">
          <i class="material-icons">add</i>
        </div>
      </div>
    </div>
    <!-- リスト表示部分 -->
    <div>
      <ul class="collection">
        <!-- 
          <li id="row_task_1" class="collection-item">
          <label for="task_1">
          <input type="checkbox" id="task_1" />
            <span>Sample Task</span>
            </label>
        </li>
        <li id="row_task_2" class="collection-item">
          <label for="task_2">
          <input type="checkbox" id="task_2" />
            <span>Sample Task</span>
            </label>
        </li>
        <li id="row_task_3" class="collection-item">
          <label for="task_3">
          <input type="checkbox" id="task_3" />
            <span>Sample Task</span>
            </label>
        </li> 
        -->
        <li v-for="task in tasks" v-if="!task.is_done" v-bind:key="'row_task_' + task.id" class="collection-item"> 
          <label v-bind:for="'task_' + task.id">
          <input type="checkbox" v-on:change="doneTask(task.id)" v-bind:id="'task_' + task.id" />
          <span>{{ task.name }}</span></label>
        </li>
      </ul>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div class="btn" v-on:click="displayFinishedTasks">Display finished tasks</div>
    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" class="display_none">
      <ul class="collection">
        <!--
        <li id="row_task_4" class="collection-item">
          <label v-bind:for="task_4" class="line-through">
          <input type="checkbox" id="'task_4" checked="checked" />
            <span>Done Task</span></label>
        </li>
        <li id="row_task_5" class="collection-item">
          <label v-bind:for="task_5" class="line-through">
          <input type="checkbox" id="'task_5" checked="checked" />
            <span>Done Task</span></label>
        </li>
        -->
        <li v-for="task in tasks" v-if="task.is_done" v-bind:key="'row_task_' + task.id" class="collection-item">
          <label v-bind:for="'task_' + task.id"  class="line-through">
          <input type="checkbox" v-bind:id="'task_' + task.id" checked="checked" />
          <span>{{ task.name }}</span></label>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';
  export default {
    data: function () {
      return {
        tasks: [],
        newTask: ''
      }
    },
    mounted: function () {
      this.fetchTasks();
    },
    methods: {
      fetchTasks: function () {
        axios.get('/api/tasks').then((response) => {
          for(var i = 0; i < response.data.tasks.length; i++) {
            this.tasks.push(response.data.tasks[i]);
          }
        }, (error) => {
          console.log(error);
        });
      },
      createTask: function () {
        if (!this.newTask) return;
        axios.post('/api/tasks', { task: { name: this.newTask } }).then((response) => {
          this.tasks.unshift(response.data.task);
          this.newTask = '';
        }, (error) => {
          console.log(error);
        });
      },
      doneTask: function (task_id) {
        axios.put('/api/tasks/' + task_id, { task: { is_done: 1 } }).then((response) => {
          this.moveFinishedTask(task_id);
        }, (error) => {
          console.log(error);
        });
      },
      displayFinishedTasks: function() {
        document.querySelector('#finished-tasks').classList.toggle('display_none');
      },
      moveFinishedTask: function(task_id) {
        var el = document.querySelector('#row_task_' + task_id);
        // DOMをクローンしておく
        var el_clone = el.cloneNode(true);
        // 未完了の方を先に非表示にする
        el.classList.add('display_none');
        // もろもろスタイルなどをたして完了済みに追加
        el_clone.getElementsByTagName('input')[0].checked = 'checked';
        el_clone.getElementsByTagName('label')[0].classList.add('line-through');
        el_clone.getElementsByTagName('label')[0].classList.remove('word-color-black');
        var li = document.querySelector('#finished-tasks > ul > li:first-child');
        document.querySelector('#finished-tasks > ul').insertBefore(el_clone, li);
      }
    }
  }
</script>

<style scoped>
  [v-cloak] {
    display: none;
  }
  .display_none {
    display:none;
  }
  
  .line-through {
    text-decoration: line-through;
  }
</style>