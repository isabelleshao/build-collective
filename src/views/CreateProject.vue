<template lang="html">
  <!--project-->
  <div class="home">
    <form @submit.prevent="createProject">
      <card
        title="Add a project"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <div class="explanations">
          Attention : le nombre de token donné sera déduit de votre compte.
          Merci de bien verifier le solde de votre compte, sinon une exception
          se declenchera. (pour rappel, vous avez sur votre compte utilisateur
          {{ accountBalance }} tokens
          <span v-if="this.companyname.length > 0">
            et sur votre compte société {{ companyAccountBalance }} tokens</span
          >).
        </div>
        <input
          type="text"
          class="input-projectname"
          v-model="projectName"
          placeholder="Type your projectname here"
          required="required"
        />

        <input
          type="number"
          class="input-projectbalance"
          v-model="projectBalance"
          placeholder="Type your balance here"
          min="0"
          required="required"
        />

        <input
          type="text"
          class="input-projectrepository"
          v-model="projectRepo"
          placeholder="Type your git repository link here"
          required="required"
        />

        <div class="explanations" v-if="this.companyname.length > 0">
          Created by :

          <div>
            <input
              type="radio"
              id="user"
              name="createdby"
              value="user"
              v-model="createdByUserOrCompany"
              required="required"
            />
            <label for="user">user :</label> {{ this.username }}
          </div>

          <div>
            <input
              type="radio"
              id="company"
              name="createdby"
              value="company"
              v-model="createdByUserOrCompany"
            />
            <label for="company"> company : {{ this.companyname }} </label>
          </div>
        </div>
        <input type="submit" value="Submit" class="btn" />
      </card>
    </form>
  </div>
  <PreviousPage />
  <!--END project-->
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import PreviousPage from '@/views/components/PreviousPage.vue'
export default defineComponent({
  name: 'createProject',
  components: { Card, PreviousPage },

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
    const companyname = ''
    const companyAccount = null
    const projectName = ''
    const projectBalance = null
    const projectRepo = ''
    const createdByUserOrCompany = null
    const accountBalance = 0
    const companyAccountBalance = 0

    return {
      account,
      username,
      companyname,
      companyAccount,
      projectName,
      projectBalance,
      projectRepo,
      createdByUserOrCompany,

      accountBalance,
      companyAccountBalance,
    }
  },
  methods: {
    async updateAccount() {
      const { contract } = this
    },

    async createProject() {
      const {
        address,
        contract,
        projectName,
        projectBalance,
        projectRepo,
        createdByUserOrCompany,
      } = this
      const name = projectName.trim().replace(/ /g, '_')
      const repoLink = projectRepo.trim().replace(/ /g, '_')
      let createdbyUser = null
      let choosen = null

      if (this.companyname.length > 0) {
        if (createdByUserOrCompany == 'user') {
          choosen = await contract.methods.user(address).call()
          createdbyUser = true
        } else {
          choosen = await contract.methods.company(address).call()
          createdbyUser = false
        }
      } else {
        choosen = await contract.methods.user(address).call()
        createdbyUser = true
      }

      console.log(choosen)
      await contract.methods
        .createProject(name, projectBalance, repoLink, createdbyUser)
        .send()
      await this.updateAccount()
      this.projectName = ''
      this.projectBalance = null
      this.projectRepo = ''
    },
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) {
      this.account = account
    }
    if (account.username != null) {
      this.username = account.username
    }
    this.accountBalance = account.balance
    const companyAccount = await contract.methods.company(address).call()

    if (companyAccount.name != null) {
      this.companyname = companyAccount.name
      this.companyAccount = companyAccount
      this.companyAccountBalance = companyAccount.balance
    }
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
.input-projectrepository,
.input-projectbalance,
.input-projectname {
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
