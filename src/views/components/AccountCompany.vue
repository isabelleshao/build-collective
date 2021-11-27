<template lang="html">
  <!-- COMPANY-->
  <div class="home" v-if="!accountCompany">
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
        />
        <!--   <input
          type="text"
          class="input-companybalance"
          v-model="companyBalance"
          placeholder="Type your company balance here"
        />-->
      </card>
    </form>
  </div>
  <div class="home" v-if="accountCompany">
    <div class="card-home-wrapper">
      <card
        :title="accountCompany.name"
        :subtitle="`${balance} Ξ\t\t${accountCompany.balance} Tokens`"
        :gradient="true"
      >
        <div class="explanations">
          {{ companyName }}
          {{ companyBalance }}
          {{ accountCompany.balance }}
          {{ accountCompany.name }}
          {{ address }}
          {{ balance }}
        </div>
        <div class="explanations">
          On your account on the contract, you have
          {{ account.balance }} tokens. If you click
          <button class="button-link" @click="addTokens">here</button>, you can
          add some token to your account. Just give it a try! And think to put
          an eye on Ganache!
        </div>
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
    async updateCompanyAccount() {
      const { address, contract } = this
      this.companyAccount = await contract.methods.company(address).call()
    },
    async signUpCompany() {
      const { contract, companyName, companyBalance } = this
      const name = companyName.trim().replace(/ /g, '_')
      // const balance = companyBalance.trim().replace(/ /g, '_')
      await contract.methods.signUpCompany(name, 0).send()
      await this.updateCompanyAccount()
      this.companyName = ''
    },

    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateCompanyAccount()
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
