<template lang="html">
  test
  <div v-for="company in listOfCompanies" :key="company.name">
    <card :title="company.name" subtitle="Hooray">
      <div class="explanations">
        <ul>
          <li><b>name</b>: {{ company.name }}</li>
          <li><b>owner</b>: {{ company.owner }}</li>
          <li><b>balance</b>: {{ company.balance }}</li>
        </ul>
      </div>
    </card>
    <spacer :size="24" />
  </div>

  <PreviousPage />
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import Spacer from '@/components/Spacer.vue'
import PreviousPage from '@/views/components/PreviousPage.vue'
export default defineComponent({
  name: 'CompaniesList',
  components: { Card, Spacer, PreviousPage },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    //const username = ''
    const accountCompany = null
    const projectsList = null
    const listOfCompanies = null
    return { account, accountCompany, projectsList, listOfCompanies }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
      this.projectsList = await contract.methods.getProjects().call()
      console.log(this.$refs.proj)
    },

    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
  },

  //Vue calls the mounted() hook when your component is added to the DOM.
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    this.listOfCompanies = await contract.methods.getCompanies().call()
    if (account.registered) this.account = account
    this.projectsList = await contract.methods.getProjects().call()
    // console.log(this.projectsList)
  },
})
</script>
<style lang="css" scoped></style>
