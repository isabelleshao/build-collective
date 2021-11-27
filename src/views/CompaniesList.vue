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
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import Spacer from '@/components/Spacer.vue'
export default defineComponent({
  name: 'CompaniesList',
  components: { Card, Spacer },
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
<style lang="css" scoped>
/*
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 500px;
  margin: auto;
}
.explanations {
  padding: 12px;
}
.button-link {
  display: inline;
  appearance: none;
  border: none;
  background: none;
  color: inherit;
  text-decoration: underline;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  padding: 0;
  margin: 0;
  cursor: pointer;
}
.input-username,
.input-projectname,
.input-companyname {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}
*/
</style>
