<template lang="html">
  <div v-for="projet in projectsList" :key="projet.name">
    <Project :projet="projet" />
    <spacer :size="24" />
  </div>
  <PreviousPage />
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Spacer from '@/components/Spacer.vue'
import PreviousPage from '@/views/components/PreviousPage.vue'
import Project from '@/views/components/Project.vue'
export default defineComponent({
  name: 'ProjectsList',
  components: { Spacer, PreviousPage, Project },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    const accountCompany = null
    const projectsList = null
    const bountiesList = null

    return { account, accountCompany, projectsList, bountiesList }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
      this.projectsList = await contract.methods.getProjects().call()
    },
  },

  //Vue calls the mounted() hook when your component is added to the DOM.
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
    this.projectsList = await contract.methods.getProjects().call()
    this.bountiesList = await contract.methods.getBounties().call()
  },
})
</script>
<style lang="css" scoped>
.links {
  padding: 24px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  width: 500px;
  margin: auto;
}
</style>
