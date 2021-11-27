<template lang="html">
  <!--project-->
  <div class="home">
    <form @submit.prevent="createProject">
      <card
        title="Add a project"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
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

        <div class="explanations">
          Created by :

          <div>
            <input
              type="radio"
              id="user"
              name="createdby"
              value="user"
              v-model="picked"
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
              v-model="picked"
            />
            <label for="company"> company : {{ this.companyname }} </label>
          </div>
        </div>

        <div>Choisi : {{ picked }}</div>
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
    const picked = null
    const projectsList = null

    return {
      account,
      username,
      companyname,
      companyAccount,

      projectsList,
      projectName,
      projectBalance,
      projectRepo,
      picked,
    }
  },
  methods: {
    async updateAccount() {
      const { contract } = this
      // this.project = await contract.methods.project(address).call()
      this.projectsList = await contract.methods.getProjects().call()

      // this.$emit('projectsList', this.projectsList)
      this.$emit('projectCreated')
    },

    async createProject() {
      const {
        address,
        contract,
        projectName,
        projectBalance,
        projectRepo,
        picked,
      } = this
      const name = projectName.trim().replace(/ /g, '_')
      const repoLink = projectRepo.trim().replace(/ /g, '_')
      let createdbyUser = null
      let choosen = null

      if (this.companyname.length > 0) {
        if (picked == 'user') {
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

    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
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

    const companyAccount = await contract.methods.company(address).call()

    if (companyAccount.name != null) {
      this.companyname = companyAccount.name
      this.companyAccount = companyAccount
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
  padding: 12px;
  font-size: 1.3rem;
  font-weight: 300;
  color: #777575;
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
