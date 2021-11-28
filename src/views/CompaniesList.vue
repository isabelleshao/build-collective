<template lang="html">
  <div v-for="company in listOfCompanies" :key="company.name">
    <card :title="company.name" subtitle="Hooray">
      <div class="explanations">
        <ul>
          <li><b>name</b>: {{ company.name }}</li>
          <li><b>owner</b>: {{ company.owner }}</li>
          <li><b>balance</b>: {{ company.balance }}</li>
          <li><b>Members</b>: {{ company.members }}</li>
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
    const accountCompany = null
    const listOfCompanies = null
    return { account, accountCompany, listOfCompanies }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
    },
  },

  //Vue calls the mounted() hook when your component is added to the DOM.
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    this.listOfCompanies = await contract.methods.getCompanies().call()
    if (account.registered) this.account = account
  },
})
</script>
<style lang="css" scoped></style>
