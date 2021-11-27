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
        <input type="submit" value="Submit" class="btn" />
      </card>
    </form>
  </div>

  <!--END project-->
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  name: 'createProject',
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
    // const username = ''
    const companyAccount = null
    const project = null

    const projectName = ''
    const projectBalance = null
    const projectRepo = ''

    const projectsList = null

    return {
      account,
      // username,
      companyAccount,
      //   project,
      projectsList,
      projectName,
      projectBalance,
      projectRepo,
    }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      // this.project = await contract.methods.project(address).call()
      this.projectsList = await contract.methods.getProjects().call()

      // this.$emit('projectsList', this.projectsList)
      this.$emit('projectCreated')
    },

    async createProject() {
      const { contract, projectName, projectBalance, projectRepo } = this
      const name = projectName.trim().replace(/ /g, '_')
      const repoLink = projectRepo.trim().replace(/ /g, '_')
      await contract.methods
        .createProject(name, projectBalance, repoLink)
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
    if (account.registered) this.account = account

    const companyAccount = await contract.methods.company(address).call()
    if (companyAccount.name) this.companyAccount = companyAccount
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
</style>
