<template lang="html">
  <div class="links">
    <card title="Back!" subtitle="Hooray" :blue="true">
      <collective-button :transparent="true" @click="goToIndex">
        Back
      </collective-button>
    </card>
  </div>
</template>
<script lang="ts">
import { defineComponent } from 'vue'
import Card from '@/components/Card.vue'
import CollectiveButton from '@/components/CollectiveButton.vue'

export default defineComponent({
  name: 'PreviousPage',
  components: { Card, CollectiveButton },

  methods: {
    goToIndex() {
      this.$router.push({ name: 'Account' })
    },
  },
})
</script>
<style lang="css" scoped>
.links {
  display: flex;
  flex-direction: column;
  justify-content: center;
  width: 100%;
  margin: auto;
}
</style>
