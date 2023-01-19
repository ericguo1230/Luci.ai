'use strict';
module.exports = app => {
    class SWPController extends app.Controller {
        async process () {
            const {ctx, app} = this;
            let response = {}

            const data = ctx.request.body;
            try {
                if (data.action && data.credential){
                    const company = data.company;
                    if (data.action == 'get-swp-report-options'){
                        response = await this.getSWPReportOptions(data.area);
                    }else if (data.action == 'get-ponds-latest-record'){
                        response = await this.getPondsLatestRecord(data.areaUUID);
                    }else if (data.action === 'get-depth-alert') {
                        response = await this.getDepthData(data.areaUUID);
                    }else if (data.action === 'get-ponds-alert-status') {
                        response = await this.getPondAlertStatus(data.areaUUID);
                    }else if (data.action === 'get-pond-info-by-id'){
                        response = await this.getPondInfoById(data.pond);
                    }else if (data.action === 'get-points'){
                        response = await this.getPoints(data.uuid);
                    }else if (data.action === 'get-all-by-time-range'){
                        response = await this.getAllByTimeRange(data, data.pond, data.types);
                    }else if (data.action === 'get-pond-weather'){
                        response = await this.getPondWeather(data.pond);
                    }
                }
            } catch(error){
                console.error('Swp: ', error.message);
                response = { error: error.message};
            }
            ctx.body = response;
    
        }

        async getSWPReportOptions(area){
            return await this.ctx.service.swp.getSWPReportOptions(area);
        }

        async getPondsLatestRecord(area){
            return await this.ctx.service.swp.getPondsLatestRecord(area);
        }

        async getDepthData(area){
            return await this.ctx.service.swp.getDepthData(area);
        }

        async getPondAlertStatus(area){
            return await this.ctx.service.swp.getPondAlertStatus(area);
        }

        async getPondInfoById(pond){
            return await this.ctx.service.swp.getPondInfoById(pond);
        }

        async getPoints(pond){
            return await this.ctx.service.swp.getPoints(pond);
        }

        async getAllByTimeRange(data, pond, types){
            return await this.ctx.service.swp.getAllByTimeRange(data, pond, types);
        }

        async getPondWeather(pondUUID){
            return await this.ctx.service.swp.getPondWeather(pondUUID);
        }
    }
    return SWPController;
}