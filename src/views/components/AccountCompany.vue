<template lang="html">
  <!-- COMPANY-->
  <div class="home" v-if="!companyAccount">
    <form @submit.prevent="signUpCompany">
      <card
        title="Enter your company name here"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <input
          type="text"
          class="input-companyname"
          v-model="companyName"
          placeholder="Type your company name here"
          required="required"
        />
        <input
          type="number"
          class="input-companybalance"
          v-model="companyBalance"
          placeholder="Type your company balance here"
          required="required"
          min="0"
        />

        <input type="submit" value="Submit" class="btn" />
      </card>
    </form>
  </div>
  <div class="home" v-if="companyAccount">
    <div class="card-home-wrapper">
      <card
        :title="`Your company : ${companyAccount.name}`"
        :subtitle="` Ξ\t\t${companyAccount.balance} Tokens`"
        :gradient="true"
      >
        <ul>
          <li><b>name</b>: {{ companyAccount.name }}</li>
          <li><b>owner</b>: {{ companyAccount.owner }}</li>
          <li><b>Token balance</b>: {{ companyAccount.balance }} tokens</li>
          <li><b>Owner ETH balance</b>: {{ balance }} tokens</li>

          <li><b>contributors</b>:</li>
        </ul>
      </card>
    </div>
  </div>
  <!-- END COMPANY-->
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  name: 'AccountCompany',
  components: { Card },

  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },

  data() {
    const companyOwner = null
    const companyName = ''
    const companyBalance = ''
    const companyAccount = null
    return { companyOwner, companyName, companyBalance, companyAccount }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.companyAccount = await contract.methods.company(address).call()
    },
    async signUp() {
      const { contract, companyName } = this
      const name = companyName.trim().replace(/ /g, '_')
      await contract.methods.signUp(name).send()
      await this.updateAccount()
      this.companyName = ''
    },

    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.company(address).call()
    this.companyAccount = account
  },
})
</script>
<style lang="css" scoped>
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

.input-companybalance,
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
</style>
