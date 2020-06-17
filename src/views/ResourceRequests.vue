<template>
  <div id="requests">
    <PendingRequests class="pending"></PendingRequests>
    <RecentlyAccepted class="recent"></RecentlyAccepted>
  </div>
</template>

<script>
import PendingRequests from '@/components/ResourceRequests/PendingRequests'
import RecentlyAccepted from '@/components/ResourceRequests/RecentlyAccepted'
  export default {
    name: 'ResourceRequests',
    components: {
      PendingRequests,
      RecentlyAccepted
    },
    data: () => ({

    }),
  }
</script>

<style scoped>
  #requests {
    height: 100%;
  }

  .pending {
    height: 100%;
    width: 50%;
    position: absolute;
    top: 0;
    left: 0;
    overflow-x: hidden;
    /* background: red; */
  }

  .recent {
    height: 100%;
    width: 50%;
    position: absolute;
    top: 0;
    right: 0;
    overflow-x: hidden;
    /* background: green; */
  }
</style>