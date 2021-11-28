<template lang="html">
  <!--ACCOUNT-->
  <div class="home" v-if="!account">
    <form @submit.prevent="signUp">
      <card
        title="Enter your username here"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <div class="explanations">
          Une fois connecté, vous aurez accès à tout le site (création
          entreprise, projet, liste des projets...)
        </div>
        <input
          type="text"
          class="input-username"
          v-model="username"
          placeholder="Type your username here"
        />
      </card>
    </form>
  </div>
  <div class="home" v-if="account">
    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`${balance} Ξ\t\t${account.balance} Tokens`"
        :gradient="true"
      >
        <ul>
          <li><b>name</b>: {{ account.username }}</li>
          <li><b>Token balance</b>: {{ account.balance }}</li>
          <li><b>Eth balance</b>: {{ balance }}</li>
          <li><b>address</b>: {{ address }}</li>
          <li><b>registered</b>: {{ account.registered }}</li>
          <li><b>contract address</b>: {{ contract._address }}</li>
        </ul>

        <div class="explanations">
          On your account on the contract, you have
          {{ account.balance }} tokens.<br />
          Add 200 token :
          <button class="button-link" @click="addTokens">click here</button>
        </div>
      </card>
    </div>
  </div>
  <!--END ACCOUNT-->
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  name: 'AccountUser',
  components: { Card },

  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    const username = ''
    const accountCompany = null
    const projectsList = null
    return { account, username, accountCompany, projectsList }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
      this.$emit('update', this.account)
    },
    async signUp() {
      const { contract, username } = this
      const name = username.trim().replace(/ /g, '_')
      await contract.methods.signUp(name).send()
      await this.updateAccount()
      this.username = ''
    },

    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
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
  padding: 5px;
  font-size: 1.2rem;
  font-weight: 500;
  color: rgb(240, 240, 240);
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

.btn {
  margin: auto;
  width: 100%;
  background: rgb(89, 25, 138);
  color: white;
  font-size: 1.3rem;
}
</style>
